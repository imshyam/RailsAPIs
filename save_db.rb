require './get_current.rb'
require 'sqlite3'
class SaveDB
	@db
	@@dataAll
	@@data
	def self.dataAll
		@@dataAll
	end
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
	def deleteOlder(period, timeInSecs)
		delete_query = "DELETE FROM histories WHERE period = " +
							"\"" + period + "\" and date_time < \"" + (Time.now - timeInSecs).getutc.to_s + "\""
		puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" + period + "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
		puts delete_query
		@db.execute delete_query
	end
	def reinit(period, buy, sell)
		@@data["count" + period] = 1
		@@data["sum" + period + "Buy"] =  buy.to_f
		@@data["sum" + period + "Sell"] =  sell.to_f
		@@data["firstEntryTime" + period] = Time.now.getutc
	end
	def updateInData(updateTo, buy, sell, crypto_curr, curr, exchange_id)
		for period in updateTo
			@@data["count" + period] += 1
			@@data["sum" + period + "Buy"] +=  buy.to_f
			@@data["sum" + period + "Sell"] += sell.to_f
			insertHistory(period.downcase, crypto_curr, curr, exchange_id,
														@@data['firstEntryTime' + period], 
														@@data['sum' + period + 'Buy'] / @@data['count' + period], 
														@@data['sum' + period + 'Buy'] / @@data['count' + period])
		end
	end
	def insertHistory(period, crypto_curr, curr, exchange_id, date_time, buy, sell)
		query_history =  "REPLACE INTO "+
								"histories ( period, " + 
										   "crypto_curr, " +
										   "curr, " +
										   "exchange_id, " +
										   "date_time, " +
										   "buy, " +
										   "sell) VALUES ( \"" + period + "\", " +
								"\"" + crypto_curr + "\", " +
								"\"" + curr + "\", " +
								exchange_id.to_s + ", " +
								"\"" + date_time.to_s + "\", " +
								buy.to_s + ", " + 
								sell.to_s +
								")"
		puts "################------------   " + period + "     -------------####################"
		puts query_history
		@db.execute query_history
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

	def initialize(dataAll)
		@@dataAll = Hash[]
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
	    # Make Unique index for currents Update or Insert Entry
	    @db.execute "CREATE UNIQUE INDEX IF NOT EXISTS " +
	    			"crypto_curr_id " +
	    			"ON " +
	    			"currents (crypto_curr, curr, exchange_id);"


	    @db.execute "CREATE TABLE IF NOT EXISTS histories(
					id INTEGER PRIMARY KEY AUTOINCREMENT,
	        		period TEXT,
	        		crypto_curr TEXT,
	        		curr TEXT,
	        		exchange_id INTEGER,
	        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	        		buy DOUBLE,
	        		sell DOUBLE
	        		)"
	    # Make Unique index for histories to update when time and period are same
	    @db.execute "CREATE UNIQUE INDEX IF NOT EXISTS " +
	    			"period_time_id " +
	    			"ON " +
	    			"histories (period, date_time, exchange_id);"
	    res = GetData.new.getResult
	    for ex_data in res
	    	if dataAll[ex_data['exchange_id']].nil?
	    		@@data = Hash[]
	    	else
	    		@@data = dataAll[ex_data['exchange_id']]
	    	end
	    	if ex_data['success']
	    		buy_sell = @db.execute "SELECT buy, sell FROM currents " +
	    			  "WHERE crypto_curr = \"" + ex_data['crypto_curr'] + "\" " +
	    			  "AND curr = \"" + ex_data['curr'] + "\" " +
	    			  "AND exchange_id = " + ex_data['exchange_id'].to_s
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

				puts query_current
				puts "=======================***********************================================"
				@db.execute query_current

				# Handle History

				# Update these values in @@data
				updateTo = ["Day", "Week", "Month", "All"]

				# Delete older details
				deleteOlder("hour", 3600)
				deleteOlder("day", 86400)
				deleteOlder("week", 604800)
				deleteOlder("month", 2592000)

				# Reinitialize data after some period
				# Avg of 8 mins
				if @@data["firstEntryTimeDay"].nil? or Time.now.getutc - @@data["firstEntryTimeDay"] > 480
					reinit("Day", ex_data["buy"], ex_data["sell"])
					updateTo.delete("Day")
					puts @@data['sumDayBuy'].class
					insertHistory("day", ex_data['crypto_curr'], ex_data['curr'], ex_data['exchange_id'],
														@@data['firstEntryTimeDay'], 
														@@data['sumDayBuy'] / @@data['countDay'], 
														@@data['sumDayBuy'] / @@data['countDay'])
				end
				# Avg of 1 hour
				if @@data["firstEntryTimeWeek"].nil? or Time.now.getutc - @@data["firstEntryTimeWeek"] > 3600
					reinit("Week", ex_data["buy"], ex_data["sell"])
					updateTo.delete("Week")
					insertHistory("week", ex_data['crypto_curr'], ex_data['curr'], ex_data['exchange_id'],
														@@data['firstEntryTimeWeek'], 
														@@data['sumDayBuy'] / @@data['countWeek'], 
														@@data['sumDayBuy'] / @@data['countWeek'])
				end
				# Avg of 4 hours
				if @@data["firstEntryTimeMonth"].nil? or Time.now.getutc - @@data["firstEntryTimeMonth"] > 14400
					reinit("Month", ex_data["buy"], ex_data["sell"])
					updateTo.delete("Month")
					insertHistory("month", ex_data['crypto_curr'], ex_data['curr'], ex_data['exchange_id'],
														@@data['firstEntryTimeMonth'], 
														@@data['sumDayBuy'] / @@data['countMonth'], 
														@@data['sumDayBuy'] / @@data['countMonth'])
				end
				# Avg of 2 days
				if @@data["firstEntryTimeAll"].nil? or Time.now.getutc - @@data["firstEntryTimeAll"] > 172800
					reinit("All", ex_data["buy"], ex_data["sell"])
					updateTo.delete("All")
					insertHistory("all", ex_data['crypto_curr'], ex_data['curr'], ex_data['exchange_id'],
														@@data['firstEntryTimeAll'], 
														@@data['sumDayBuy'] / @@data['countAll'], 
														@@data['sumDayBuy'] / @@data['countAll'])
				end

				# Update remaining
				updateInData(updateTo, ex_data["buy"], ex_data["sell"], ex_data['crypto_curr'], 
													   ex_data['curr'], ex_data['exchange_id'])

				# Insert Hour
				insertHistory("hour", ex_data['crypto_curr'], ex_data['curr'], ex_data['exchange_id'],
														Time.now.getutc, ex_data['buy'], ex_data['sell'])

	    		@@dataAll[ex_data['exchange_id']] = @@data
			end
		end
	rescue SQLite3::Exception => e
		puts "Exception"
		puts e
	ensure
		@db.close if @db
	end
end