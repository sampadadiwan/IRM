module AccountEntryAllocation
  ############################################################
  # 1. RunFormulas Operation
  ############################################################
  class RunFormulas < AllocationBaseOperation
    step :cleaup_prev_allocations
    step :run_formulas
    step :generate_fund_ratios
    step :generate_soa

    def cleaup_prev_allocations(_ctx, fund:, start_date:, end_date:, **)
      fund.account_entries.generated.where(reporting_date: start_date..end_date).delete_all
    end

    def run_formulas(ctx, **)
      return unless ctx[:run_allocations]

      fund                 = ctx[:fund]
      rule_for             = ctx[:rule_for]
      tag_list             = ctx[:tag_list]
      user_id              = ctx[:user_id]
      allocation_run       = ctx[:allocation_run]
      start_date           = ctx[:start_date]
      end_date             = ctx[:end_date]
      run_start_time       = Time.zone.now
      ctx[:bulk_insert_records] = []

      # Get the enabled formulas
      formulas = FundFormula.enabled.where(fund_id: fund.id).order(sequence: :asc)
      formulas = formulas.where(rule_for: rule_for) if rule_for.present?
      formulas = formulas.with_tags(tag_list.split(",")) if tag_list.present?

      ctx[:formula_count] = formulas.count

      formulas.each_with_index do |fund_formula, index|
        ctx[:formula_index] = index
        start_time = Time.zone.now

        # Call sub-operation to run the formula
        # We re-use the same ctx for sub-ops, but add the current fund_formula:
        sub_ctx = ctx.merge(fund_formula: fund_formula)
        result = AccountEntryAllocation::RunFormula.wtf?(sub_ctx)
        if result.failure? && result[:error].present?
          # If there's an error, log/raise as needed
          # The sub-operation might raise an error, or we can handle it here
          raise result[:error]
        end

        # Update execution_time
        fund_formula.update_column(:execution_time, ((Time.zone.now - start_time) * 1000).to_i)

        # Provide notification
        notify("Completed #{index + 1} of #{ctx[:formula_count]}: #{fund_formula.name}", :success, user_id)
      rescue StandardError => e
        error_message = "Error in Formula #{fund_formula.sequence}: #{fund_formula.name} : #{e.message}"
        notify(error_message, :danger, user_id)
        Rails.logger.debug { error_message }
        allocation_run&.update_column(:status, error_message)
        raise e
      end

      time_taken = ((Time.zone.now - run_start_time)).to_i
      notify("Done running #{ctx[:formula_count]} formulas for #{start_date} - #{end_date} in #{time_taken} seconds", :success, user_id)
      allocation_run&.update_column(:status, "Success")
      true
    end

    # rubocop:disable Lint/RescueException
    def generate_fund_ratios(ctx, fund:, start_date:, end_date:, user_id:, **)
      if ctx[:fund_ratios]
        begin
          FundRatiosJob.perform_now(fund.id, nil, end_date, user_id, true)
          msg = "Done generating fund ratios for #{start_date} - #{end_date}"
          Rails.logger.info msg
          notify(msg, :success, user_id)
          true
        rescue Exception => e
          Rails.logger.error e.backtrace
          msg = "Error generating fund ratios for #{start_date} - #{end_date}: #{e.message}"
          Rails.logger.error msg
          notify(msg, :danger, user_id)
          false
        end
      else
        true
      end
    end
    # rubocop:enable Lint/RescueException

    # rubocop:disable Lint/RescueException
    def generate_soa(ctx, fund:, start_date:, end_date:, user_id:, **)
      if ctx[:generate_soa]
        begin
          CapitalCommitmentSoaJob.perform_later(fund.id, nil, start_date.to_s, end_date.to_s, user_id, template_id:)
          msg = "Done generating SOA for #{start_date} - #{end_date}"
          Rails.logger.info msg
          notify(msg, :success, user_id)
          true
        rescue Exception => e
          Rails.logger.error e.backtrace
          msg = "Error generating SOA for #{start_date} - #{end_date}: #{e.message}"
          Rails.logger.error msg
          notify(msg, :danger, user_id)
          false
        end
      else
        true
      end
    end
    # rubocop:enable Lint/RescueException
  end
end
