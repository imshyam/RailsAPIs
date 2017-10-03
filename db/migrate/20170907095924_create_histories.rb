class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy
      t.decimal :sell
      t.datetime :date_time
      
    end
  end
end
