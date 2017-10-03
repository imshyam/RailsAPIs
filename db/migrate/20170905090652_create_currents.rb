class CreateCurrents < ActiveRecord::Migration[5.1]
  def change
    create_table :currents do |t|
      t.string :crypto_curr
      t.string :curr
      t.integer :exchange_id
      t.decimal :buy
      t.decimal :sell
      t.decimal :volume
      t.float :last_hour_min_buy
      t.float :last_day_min_buy
      t.float :last_week_min_buy
      t.float :last_month_min_buy
      t.float :last_hour_max_buy
      t.float :last_day_max_buy
      t.float :last_week_max_buy
      t.float :last_month_max_buy
      t.float :last_hour_min_sell
      t.float :last_day_min_sell
      t.float :last_week_min_sell
      t.float :last_month_min_sell
      t.float :last_hour_max_sell
      t.float :last_day_max_sell
      t.float :last_week_max_sell
      t.float :last_month_max_sell
      t.datetime :date_time

    end
  end
end
