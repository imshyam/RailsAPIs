class CreateCurrents < ActiveRecord::Migration[5.1]
  def change
    create_table :currents do |t|
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy
      t.decimal :sell
      t.decimal :volume
      t.decimal :last_hour_min
      t.decimal :last_day_min
      t.decimal :last_week_min
      t.decimal :last_month_min
      t.decimal :last_hour_max
      t.decimal :last_day_max
      t.decimal :last_week_max
      t.decimal :last_month_max

      t.timestamps :date_time
    end
  end
end
