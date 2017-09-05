class CreateCurrents < ActiveRecord::Migration[5.1]
  def change
    create_table :currents do |t|
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy, :precision=>5, :scale=>12
      t.decimal :sell, :precision=>5, :scale=>12
      t.decimal :last_hour_min, :precision=>5, :scale=>12
      t.decimal :last_day_min, :precision=>5, :scale=>12
      t.decimal :last_week_min, :precision=>5, :scale=>12
      t.decimal :last_month_min, :precision=>5, :scale=>12
      t.decimal :last_hour_max, :precision=>5, :scale=>12
      t.decimal :last_day_max, :precision=>5, :scale=>12
      t.decimal :last_week_max, :precision=>5, :scale=>12
      t.decimal :last_month_max, :precision=>5, :scale=>12

      t.timestamps
    end
  end
end
