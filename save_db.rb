require './get_current.rb'
require 'sqlite3'

def calculateLastMinMax(curr_data)
	query_last_hour_min = "SELECT MAX(buy) FROM 'currents' where date_time > datetime('now', '-24 hours') and crypto_curr = "Bitcoin" and curr = "SGD" and exchange_id = 1;"
	x = Hash['last_hour_min_buy'=> -1,
			 'last_day_min_buy'=> -1,
			 'last_week_min_buy'=> -1,
			 'last_month_min_buy'=> -1,
			 'last_hour_max_buy'=> -1,
			 'last_day_max_buy'=> -1,
			 'last_week_max_buy'=> -1,
			 'last_month_max_buy'=> -1],
			 'last_hour_min_sell'=> -1,
			 'last_day_min_sell'=> -1,
			 'last_week_min_sell'=> -1,
			 'last_month_min_sell'=> -1,
			 'last_hour_max_sell'=> -1,
			 'last_day_max_sell'=> -1,
			 'last_week_max_sell'=> -1,
			 'last_month_max_sell'=> -1]
	return x
end

begin
	db = SQLite3::Database.open "db/development.sqlite3"
	db.execute "CREATE TABLE IF NOT EXISTS currents(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INTEGER,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE,
        		last_hour_min_buy DOUBLE,
        		last_day_min_buy DOUBLE,
        		last_week_min_buy DOUBLE,
        		last_month_min_buy DOUBLE,
        		last_hour_max_buy DOUBLE,
        		last_day_max_buy DOUBLE,
        		last_week_max_buy DOUBLE,
        		last_month_max_buy DOUBLE,
        		last_hour_min_sell DOUBLE,
        		last_day_min_sell DOUBLE,
        		last_week_min_sell DOUBLE,
        		last_month_min_sell DOUBLE,
        		last_hour_max_sell DOUBLE,
        		last_day_max_sell DOUBLE,
        		last_week_max_sell DOUBLE,
        		last_month_max_sell DOUBLE
        		)"
    # Make Unique index
    db.execute "CREATE UNIQUE INDEX IF NOT EXISTS " +
    			"crypto_curr_id " +
    			"ON " +
    			"currents (crypto_curr, curr, exchange_id);"
    db.execute "CREATE TABLE IF NOT EXISTS histories(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INTEGER,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE
        		)"
    data = GetData.new.getResult
    for ex_data in data
    	if ex_data['success']
    		need_update = true
    		buy_sell = db.execute "SELECT buy, sell FROM currents " +
    			  "WHERE crypto_curr = \"" + ex_data['crypto_curr'] + "\" " +
    			  "AND curr = \"" + ex_data['curr'] + "\" " +
    			  "AND exchange_id = " + ex_data['exchange_id'].to_s
    		if !buy_sell[0].nil?
	    		buy = buy_sell[0][0]
	    		sell = buy_sell[0][1]
	    		buy_last = ex_data['buy'].to_f
	    		sell_last = ex_data['sell'].to_f
	    		if buy == buy_last && sell == sell_last
	    			need_update = false
	    		end
	    	end
    		if need_update
		    	last_min_max = calculateLastMinMax(ex_data)
		   	    query_current = "REPLACE INTO currents " +
		   	    				"(crypto_curr, curr, exchange_id, date_time, " +
		   	    				  "buy, sell, last_hour_min, last_day_min, last_week_min, " +
		   	    				  "last_month_min, last_hour_max, last_day_max, last_week_max, " +
		   	    				  "last_month_max)" +
		   	    				"VALUES ("+
								"\"" + ex_data['crypto_curr'] + "\", " +
								"\"" + ex_data['curr'] + "\", " +
								ex_data['exchange_id'].to_s + ", " +
								"\"" + Time.now.getutc.to_s + "\", " +
								ex_data['buy'].to_s + ", " + 
								ex_data['sell'].to_s + ", " + 
								last_min_max['last_hour_min'].to_s + ", " +
								last_min_max['last_day_min'].to_s + ", " +
								last_min_max['last_week_min'].to_s + ", " +
								last_min_max['last_month_min'].to_s + ", " +
								last_min_max['last_hour_max'].to_s + ", " +
								last_min_max['last_day_max'].to_s + ", " +
								last_min_max['last_week_max'].to_s + ", " +
								last_min_max['last_month_max'].to_s +
								")"
				query_history = "INSERT INTO "+
								"histories (crypto_curr, " +
										   "curr, " +
										   "exchange_id, " +
										   "date_time, " +
										   "buy, " +
										   "sell) VALUES (" +
								"\"" + ex_data['crypto_curr'] + "\", " +
								"\"" + ex_data['curr'] + "\", " +
								ex_data['exchange_id'].to_s + ", " +
								"\"" + Time.now.getutc.to_s + "\", " +
								ex_data['buy'].to_s + ", " + 
								ex_data['sell'].to_s +
								")"
				db.execute query_current
				db.execute query_history
			end
		else
			puts ex_data
		end
	end
rescue SQLite3::Exception => e
	puts "Exception"
	puts e
ensure
	db.close if db
end