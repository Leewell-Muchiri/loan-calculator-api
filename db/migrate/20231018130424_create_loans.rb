class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.decimal :loan_amount
      t.integer :payment_frequency
      t.integer :loan_period
      t.date :start_date
      t.string :interest_type

      t.timestamps
    end
  end
end
