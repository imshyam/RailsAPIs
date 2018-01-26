class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.string :period
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.float :buy
      t.float :sell
      t.datetime :date_time

    end
  end
end
