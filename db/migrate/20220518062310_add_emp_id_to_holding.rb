class AddEmpIdToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :employee_id, :string, limit: 20
    add_column :holdings, :import_upload_id, :bigint
  end
end
