class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :name
      t.decimal :flat_rate
      t.decimal :reducing_balance_rate

      t.timestamps
    end
  end
end
