require 'json'
require 'open-uri'

class String
    def is_i?
    	/\A[-+]?\d+\z/ === self
    end
end

class GetData
	@jsonData
	def getResponse(api)
		puts "Api"
		puts api
		puts "*****************************"
		currentData = Hash['success'=> false, 'buy'=> -1, 'sell'=> -1, 'volume'=> -1]
		# Buy, Sell and Volume are at same endpoint
		if api.length == 1
			url = api['all']['endpoint']
			buy = api['all']['buyKey'].split('.')
			sell = api['all']['sellKey'].split('.')
			volume = api['all']['volumeKey']
			# Check if Volume is provided
			if volume 
				volume = volume.split('.')
			else
				volume = -1
			end
			# Get Buy, Sell Price and Volume
			begin
				response = JSON.parse(open(url, read_timeout: 1, open_timeout: 5).read)
				puts "Single"
				puts response
				puts '=============================='
			rescue Exception => e
				currentData["success"] = false
				currentData["buy"] = -1
				currentData["sell"] = -1
				currentData["volume"] = -1
				puts currentData
			else
				currentData["success"] = true
				tmp = response
				for key in buy
					key = key.is_i? ? key.to_i : key
					tmp = tmp[key]
				end
				currentData["buy"] = tmp
				tmp = response
				for key in sell
					key = key.is_i? ? key.to_i : key
					tmp = tmp[key]
				end
				currentData["sell"] = tmp
				if volume != -1
					tmp = response
					for key in volume
						key = key.is_i? ? key.to_i : key
						tmp = tmp[key]
					end
				else
					tmp = -1
				end
				currentData["volume"] = tmp
				puts currentData
				puts '=============================='
			end
		# Buy, Sell and Volume are at different endpoint
		else
			buyEndpoint = api['buy']['endpoint']
			buyKey = api['buy']['buyKey'].split('.')
			sellEndpoint = api['sell']['endpoint']
			sellKey = api['sell']['sellKey'].split('.')
			if api['volume']
				volumeEndpoint = api['volume']['endpoint']
				volumeKey = api['volume']['volumeKey'].split('.')
			else
				volumeKey = -1
			end
			# Get Buy Price
			begin
				response = JSON.parse(open(buyEndpoint, read_timeout: 1, open_timeout: 5).read)
				puts "Multi Buy"
				puts response
				puts '=============================='
			rescue Exception => e
				currentData["success"] = false
				currentData["buy"] = -1
				currentData["sell"] = -1
				currentData["volume"] = -1
				return
			else
				tmp = response
				for key in buyKey
					key = key.is_i? ? key.to_i : key
					tmp = tmp[key]
				end
				currentData["buy"] = tmp
			end
			# Get Sell Price
			begin
				response = JSON.parse(open(sellEndpoint, read_timeout: 1, open_timeout: 5).read)
				puts "Multi Sell"
				puts response
				puts '=============================='
			rescue Exception => e
				currentData["success"] = false
				currentData["buy"] = -1
				currentData["sell"] = -1
				currentData["volume"] = -1
				return
			else
				currentData["success"] = true
				tmp = response
				for key in sellKey
					key = key.is_i? ? key.to_i : key
					tmp = tmp[key]
				end
				currentData["sell"] = tmp
			end
			# Get Volume if provided
			if volumeKey != -1
				begin
					response = JSON.parse(open(volumeEndpoint, read_timeout: 1, open_timeout: 5).read)
					puts "Multi Volume"
					puts response
					puts '=============================='
				rescue Exception => e
					currentData["volume"] = -1
				else
					tmp = response
					for key in volumeKey
						key = key.is_i? ? key.to_i : key
						tmp = tmp[key]
					end
					currentData["volume"] = tmp
				end
			end
			puts currentData
			puts '=============================='
		end
	end
	def getFileContents(file)
		text = File.read(file)
		return text
	rescue Exception => e
		puts e.message
		return -1
	end
	def getCurrent
		for keyCC in @jsonData.keys
			for keyPC in @jsonData[keyCC].keys
				for exchange in @jsonData[keyCC][keyPC]
					puts "#{keyCC} #{keyPC} #{exchange['name']}"
					result = getResponse(exchange['api'])
				end
			end
		end
	end
	def initialize
		path = './../../exchanges.json'
		@jsonData = JSON.parse(getFileContents(path))
		getCurrent
	end
end

GetData.new