require './get_current.rb'
require 'sqlite3'
class SaveDB
	@db
	def getQuery(curr_data, min_max, buy_sell, time)
		query_prefix  = "FROM histories where date_time > datetime(\"now\", \""
		query_suffix = "\") and crypto_curr = \"" +  curr_data['crypto_curr'] + "\" and curr = \"" +
							  curr_data['curr'] + "\" and exchange_id = " + curr_data['exchange_id'].to_s
		return "SELECT " + min_max + "(" + buy_sell+ ") " + query_prefix + time + query_suffix
	end
	def compareMinWithCurr(minh, curr)
		return [minh.nil? ? curr.to_f : minh, curr.to_f].min
	end
	def compareMaxWithCurr(maxh, curr)
		return [maxh.nil? ? curr.to_f : maxh, curr.to_f].max
	end
	def calculateLastMinMax(curr_data)
		# Last Hour : MIN MAX : BUY SELL
		query_last_hour_max_buy = getQuery(curr_data, "MAX", "buy", "-1 hours")
		last_hour_max_buy = (@db.execute query_last_hour_max_buy)[0][0]
		query_last_hour_max_sell = getQuery(curr_data, "MAX", "sell", "-1 hours")
		last_hour_max_sell = (@db.execute query_last_hour_max_sell)[0][0]
		query_last_hour_min_buy = getQuery(curr_data, "MIN", "buy", "-1 hours")
		last_hour_min_buy = (@db.execute query_last_hour_min_buy)[0][0]
		query_last_hour_min_sell = getQuery(curr_data, "MIN", "sell", "-1 hours")
		last_hour_min_sell = (@db.execute query_last_hour_min_sell)[0][0]

		# Last Day : MIN MAX : BUY SELL
		query_last_day_max_buy = getQuery(curr_data, "MAX", "buy", "-24 hours")
		last_day_max_buy = (@db.execute query_last_day_max_buy)[0][0]
		query_last_day_max_sell = getQuery(curr_data, "MAX", "sell", "-24 hours")
		last_day_max_sell = (@db.execute query_last_day_max_sell)[0][0]
		query_last_day_min_buy = getQuery(curr_data, "MIN", "buy", "-24 hours")
		last_day_min_buy = (@db.execute query_last_day_min_buy)[0][0]
		query_last_day_min_sell = getQuery(curr_data, "MIN", "sell", "-24 hours")
		last_day_min_sell = (@db.execute query_last_day_min_sell)[0][0]

		# Last Week : MIN MAX : BUY SELL
		query_last_week_max_buy = getQuery(curr_data, "MAX", "buy", "-7 days")
		last_week_max_buy = (@db.execute query_last_week_max_buy)[0][0]
		query_last_week_max_sell = getQuery(curr_data, "MAX", "sell", "-7 days")
		last_week_max_sell = (@db.execute query_last_week_max_sell)[0][0]
		query_last_week_min_buy = getQuery(curr_data, "MIN", "buy", "-7 days")
		last_week_min_buy = (@db.execute query_last_week_min_buy)[0][0]
		query_last_week_min_sell = getQuery(curr_data, "MIN", "sell", "-7 days")
		last_week_min_sell = (@db.execute query_last_week_min_sell)[0][0]

		# Last Month : MIN MAX : BUY SELL
		query_last_month_max_buy = getQuery(curr_data, "MAX", "buy", "-30 days")
		last_month_max_buy = (@db.execute query_last_month_max_buy)[0][0]
		query_last_month_max_sell = getQuery(curr_data, "MAX", "sell", "-30 days")
		last_month_max_sell = (@db.execute query_last_month_max_sell)[0][0]
		query_last_month_min_buy = getQuery(curr_data, "MIN", "buy", "-30 days")
		last_month_min_buy = (@db.execute query_last_month_min_buy)[0][0]
		query_last_month_min_sell = getQuery(curr_data, "MIN", "sell", "-30 days")
		last_month_min_sell = (@db.execute query_last_month_min_sell)[0][0]

		x = Hash['last_hour_min_buy'=> compareMinWithCurr(last_hour_min_buy, curr_data['buy']),
				 'last_day_min_buy'=> compareMinWithCurr(last_day_min_buy, curr_data['buy']),
				 'last_week_min_buy'=> compareMinWithCurr(last_week_min_buy, curr_data['buy']),
				 'last_month_min_buy'=> compareMinWithCurr(last_month_min_buy, curr_data['buy']),
				 'last_hour_max_buy'=> compareMaxWithCurr(last_hour_max_buy, curr_data['buy']),
				 'last_day_max_buy'=> compareMaxWithCurr(last_day_max_buy, curr_data['buy']),
				 'last_week_max_buy'=> compareMaxWithCurr(last_week_max_buy, curr_data['buy']),
				 'last_month_max_buy'=> compareMaxWithCurr(last_month_max_buy, curr_data['buy']),
				 'last_hour_min_sell'=> compareMinWithCurr(last_hour_min_sell, curr_data['sell']),
				 'last_day_min_sell'=> compareMinWithCurr(last_day_min_sell, curr_data['sell']),
				 'last_week_min_sell'=> compareMinWithCurr(last_week_min_sell, curr_data['sell']),
				 'last_month_min_sell'=> compareMinWithCurr(last_month_min_sell, curr_data['sell']),
				 'last_hour_max_sell'=> compareMaxWithCurr(last_hour_max_sell, curr_data['sell']),
				 'last_day_max_sell'=> compareMaxWithCurr(last_day_max_sell, curr_data['sell']),
				 'last_week_max_sell'=> compareMaxWithCurr(last_week_max_sell, curr_data['sell']),
				 'last_month_max_sell'=> compareMaxWithCurr(last_month_max_sell, curr_data['sell'])]
		puts x
		return x
	end

	def initialize
		@db = SQLite3::Database.open "db/development.sqlite3"
		@db.execute "CREATE TABLE IF NOT EXISTS currents(
					id INTEGER PRIMARY KEY AUTOINCREMENT,
	        		crypto_curr TEXT,
	        		curr TEXT,
	        		exchange_id INTEGER,
	        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	        		buy DOUBLE,
	        		sell DOUBLE,
	        		volume DOUBLE,
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
	    @db.execute "CREATE UNIQUE INDEX IF NOT EXISTS " +
	    			"crypto_curr_id " +
	    			"ON " +
	    			"currents (crypto_curr, curr, exchange_id);"
	    @db.execute "CREATE TABLE IF NOT EXISTS histories(
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
	    		buy_sell = @db.execute "SELECT buy, sell FROM currents " +
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
			   	    				  "buy, sell, volume, last_hour_min_buy, last_hour_min_sell, last_day_min_buy, last_day_min_sell, last_week_min_buy, last_week_min_sell, " +
			   	    				  "last_month_min_buy, last_month_min_sell, last_hour_max_buy, last_hour_max_sell, last_day_max_buy, last_day_max_sell, "+
			   	    				  "last_week_max_buy, last_week_max_sell, last_month_max_buy, last_month_max_sell) " +
			   	    				"VALUES ("+
									"\"" + ex_data['crypto_curr'] + "\", " +
									"\"" + ex_data['curr'] + "\", " +
									ex_data['exchange_id'].to_s + ", " +
									"\"" + Time.now.getutc.to_s + "\", " +
									ex_data['buy'].to_s + ", " + 
									ex_data['sell'].to_s + ", " + 
									ex_data['volume'].to_s + ", " + 
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
					puts query_history
					@db.execute query_history
					puts "*****************************"
					puts query_current
					puts "======================================================="
					@db.execute query_current
				end
			end
		end
	rescue SQLite3::Exception => e
		puts "Exception"
		puts e
	ensure
		@db.close if @db
	end
end