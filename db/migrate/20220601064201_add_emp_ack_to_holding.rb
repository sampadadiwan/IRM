class AddEmpAckToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :emp_ack, :boolean, default: false
    add_column :holdings, :emp_ack_date, :date
  end
end
