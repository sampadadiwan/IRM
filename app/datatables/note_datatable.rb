class NoteDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :check_box_tag, :link_to, :mail_to, :edit_note_path

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Note.id" },
      user_full_name: { source: "User.first_name", orderable: true },
      entity_name: { source: "Entity.name", cond: :like, searchable: true, orderable: true },
      investor_name: { source: "Investor.investor_name", cond: :like, searchable: true, orderable: true },
      created_at: { source: "Note.created_at", orderable: true },
      details: { source: "Note.details" }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        user_full_name: record.user.full_name,
        entity_name: record.entity.name,
        investor_name: record.investor.investor_name,
        created_at: record.created_at, formatter: ->(d) { d.a.strftime("%d/%m/%Y") },
        details: record.details,
        DT_RowId: record.id # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Note.where(entity_id: current_user.entity_id).joins(:user, :entity, :investor)
        .includes(:user, :entity, :investor).with_all_rich_text
  end

  def current_user
    @current_user ||= options[:current_user]
  end
end
