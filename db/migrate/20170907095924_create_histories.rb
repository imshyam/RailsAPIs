class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.integer :id
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy
      t.decimal :sell

      t.timestamps :date_time
    end
  end
end
