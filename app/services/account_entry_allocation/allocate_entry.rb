module AccountEntryAllocation
  ############################################################
  # 14. AllocateEntry Operation
  ############################################################
  class AllocateEntry < AllocationBaseOperation
    step :allocate_entry

    def allocate_entry(ctx, **)
      fund_account_entry = ctx[:fund_account_entry]
      fund_formula       = ctx[:fund_formula]
      end_date           = ctx[:end_date]
      sample             = ctx[:sample]
      commitment_cache = ctx[:commitment_cache]
      user_id            = ctx[:user_id]
      start_date         = ctx[:start_date]
      fund_unit_settings = FundUnitSetting.where(fund_id: ctx[:fund].id).index_by(&:name)

      fund_formula.commitments(end_date, sample).each_with_index do |capital_commitment, idx|
        Rails.logger.debug { "Allocating #{fund_account_entry} to #{capital_commitment}" }

        # Possibly retrieve the relevant FundUnitSetting for each commitment
        fund_unit_setting = fund_unit_settings[capital_commitment.unit_type]

        commitment_cache.computed_fields_cache(capital_commitment, start_date)
        ae = fund_account_entry.dup
        Rails.logger.debug { "fund_unit_setting: #{fund_unit_setting}, ae: #{ae}" }

        begin
          create_instance_variables(ctx)
          AccountEntryAllocation::CreateAccountEntry.wtf?(ctx.merge(account_entry: ae, capital_commitment: capital_commitment, parent: fund_account_entry, bdg: binding))
        rescue StandardError => e
          raise "Error in #{fund_formula.name} for #{capital_commitment} #{fund_account_entry}: #{e.message}"
        end

        notify("Completed #{ctx[:formula_index] + 1} of #{ctx[:formula_count]}: #{fund_formula.name} : #{idx + 1} commitments", :success, user_id) if ((idx + 1) % 10).zero?
      end

      true
    end
  end
end
