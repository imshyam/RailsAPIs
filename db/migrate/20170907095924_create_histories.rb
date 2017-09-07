class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy, :precision=>5, :scale=>12
      t.decimal :sell, :precision=>5, :scale=>12

      t.timestamps
    end
  end
end
