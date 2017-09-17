require './get_current.rb'
require 'sqlite3'
class SaveDB
	def calculateLastMinMax(curr_data)
		query_last_hour_max_buy = "SELECT MAX(buy) FROM histories where date_time > datetime('now', '-1 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		x = db.execute query_last_hour_max_buy
		
		query_last_hour_max_sell = "SELECT MAX(sell) FROM histories where date_time > datetime('now', '-1 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_hour_min_buy = "SELECT MIN(buy) FROM histories where date_time > datetime('now', '-1 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_hour_min_sell = "SELECT MIN(sell) FROM histories where date_time > datetime('now', '-1 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_day_max_buy = "SELECT MAX(buy) FROM histories where date_time > datetime('now', '-24 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_day_max_sell = "SELECT MAX(sell) FROM histories where date_time > datetime('now', '-24 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_day_min_buy = "SELECT MIN(buy) FROM histories where date_time > datetime('now', '-24 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_day_min_sell = "SELECT MIN(sell) FROM histories where date_time > datetime('now', '-24 hours') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_week_max_buy = "SELECT MAX(buy) FROM histories where date_time > datetime('now', '-7 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_week_max_sell = "SELECT MAX(sell) FROM histories where date_time > datetime('now', '-7 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_week_min_buy = "SELECT MIN(buy) FROM histories where date_time > datetime('now', '-7 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_week_min_sell = "SELECT MIN(sell) FROM histories where date_time > datetime('now', '-7 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_month_max_buy = "SELECT MAX(buy) FROM histories where date_time > datetime('now', '-30 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_month_max_sell = "SELECT MAX(sell) FROM histories where date_time > datetime('now', '-30 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_month_min_buy = "SELECT MIN(buy) FROM histories where date_time > datetime('now', '-30 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
		query_last_month_min_sell = "SELECT MIN(sell) FROM histories where date_time > datetime('now', '-30 days') and crypto_curr = \""+
							  curr_data['crypto_curr'] + "\" and curr = \""+
							  curr_data['curr']"\" and exchange_id = " + curr_data['exchange_id']
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

	def initialize
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
			   	    				  "buy, sell, last_hour_min_buy, last_hour_min_sell, last_day_min_buy, last_day_min_sell, last_week_min_buy, last_week_min_sell, " +
			   	    				  "last_month_min_buy, last_month_min_sell, last_hour_max_buy, last_hour_max_sell, last_day_max_buy, last_day_max_sell, "+
			   	    				  "last_week_max_buy, last_week_max_sell, last_month_max_buy, last_month_max_sell" +
			   	    				"VALUES ("+
									"\"" + ex_data['crypto_curr'] + "\", " +
									"\"" + ex_data['curr'] + "\", " +
									ex_data['exchange_id'].to_s + ", " +
									"\"" + Time.now.getutc.to_s + "\", " +
									ex_data['buy'].to_s + ", " + 
									ex_data['sell'].to_s + ", " + 
									last_min_max['last_hour_min_buy'].to_s + ", " +
									last_min_max['last_hour_min_sell'].to_s + ", " +
									last_min_max['last_day_min_buy'].to_s + ", " +
									last_min_max['last_day_min_sell'].to_s + ", " +
									last_min_max['last_week_min_buy'].to_s + ", " +
									last_min_max['last_week_min_sell'].to_s + ", " +
									last_min_max['last_month_min_buy'].to_s + ", " +
									last_min_max['last_month_min_sell'].to_s + ", " +
									last_min_max['last_hour_max_buy'].to_s + ", " +
									last_min_max['last_hour_max_sell'].to_s + ", " +
									last_min_max['last_day_max_buy'].to_s + ", " +
									last_min_max['last_day_max_sell'].to_s + ", " +
									last_min_max['last_week_max_buy'].to_s + ", " +
									last_min_max['last_week_max_sell'].to_s + ", " +
									last_min_max['last_month_max_buy'].to_s + ", " +
									last_min_max['last_month_max_sell'].to_s +
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
end