require './get_current.rb'
require 'sqlite3'

begin
	db = SQLite3::Database.open "development.sqlite3"
	db.execute "CREATE TABLE IF NOT EXISTS currents(
				id INTEGER PRIMARY KEY,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INT,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE,
        		last_hour_min DOUBLE,
        		last_day_min DOUBLE,
        		last_week_min DOUBLE,
        		last_month_min DOUBLE,
        		last_hour_max DOUBLE,
        		last_day_max DOUBLE,
        		last_week_max DOUBLE,
        		last_month_max DOUBLE
        		)"
    db.execute "CREATE TABLE IF NOT EXISTS histories(
				id INTEGER PRIMARY KEY,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INT,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE,
        		last_hour_min DOUBLE,
        		last_day_min DOUBLE,
        		last_week_min DOUBLE,
        		last_month_min DOUBLE,
        		last_hour_max DOUBLE,
        		last_day_max DOUBLE,
        		last_week_max DOUBLE,
        		last_month_max DOUBLE
        		)"
    data = GetData.new.getResult
    query_current = "INSERT OR REPLACE INTO data VALUES("+
					"SELECT id from currents "
					+")"
rescue SQLite3::Exception => e
	puts "Exception"
	puts e
ensure
	db.close if db
end