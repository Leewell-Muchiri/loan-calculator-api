class AddBankToLoans < ActiveRecord::Migration[7.0]
  def change
    add_reference :loans, :bank, null: false, foreign_key: true
  end
end
