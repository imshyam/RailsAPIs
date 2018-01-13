require 'json'
require 'open-uri'

class String
    def is_i?
    	/\A[-+]?\d+\z/ === self
    end
end

class GetData
	def getResponse(api)
		# Buy, Sell and Volume are at same endpoint
		currentEx = Hash['success'=> false, 'buy'=> -1, 'sell'=> -1, 'volume'=> -1]
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
				response = JSON.parse(open(url).read)
			rescue Exception => e
				currentEx["success"] = false
				currentEx["buy"] = -1
				currentEx["sell"] = -1
				currentEx["volume"] = -1
			else
				currentEx["success"] = true
				tmp = response
				for key in buy
					key = key.is_i? ? key.to_i : key
					if !tmp.nil?
						tmp = tmp[key]
					else
						currentEx["success"] = false
						tmp = -1
						break
					end
				end
				currentEx["buy"] = tmp
				tmp = response
				for key in sell
					key = key.is_i? ? key.to_i : key
					if !tmp.nil?
						tmp = tmp[key]
					else
						currentEx["success"] = false
						tmp = -1
						break
					end
				end
				currentEx["sell"] = tmp
				if volume != -1
					tmp = response
					for key in volume
						key = key.is_i? ? key.to_i : key
						if !tmp.nil?
							tmp = tmp[key]
						else
							tmp = -1
							break
						end
					end
				else
					tmp = -1
				end
				currentEx["volume"] = tmp
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
				response = JSON.parse(open(buyEndpoint).read)
			rescue Exception => e
				currentEx["success"] = false
				currentEx["buy"] = -1
				currentEx["sell"] = -1
				currentEx["volume"] = -1
				return
			else
				tmp = response
				for key in buyKey
					key = key.is_i? ? key.to_i : key
					if !tmp.nil?
						tmp = tmp[key]
					else
						currentEx["success"] = false
						tmp = -1
						break
					end
				end
				currentEx["buy"] = tmp
			end
			# Get Sell Price
			begin
				response = JSON.parse(open(sellEndpoint).read)
			rescue Exception => e
				currentEx["success"] = false
				currentEx["buy"] = -1
				currentEx["sell"] = -1
				currentEx["volume"] = -1
				return
			else
				currentEx["success"] = true
				tmp = response
				for key in sellKey
					key = key.is_i? ? key.to_i : key
					if !tmp.nil?
						tmp = tmp[key]
					else
						currentEx["success"] = false
						tmp = -1
						break
					end
				end
				currentEx["sell"] = tmp
			end
			# Get Volume if provided
			if volumeKey != -1
				begin
					response = JSON.parse(open(volumeEndpoint).read)
				rescue Exception => e
					currentEx["volume"] = -1
				else
					tmp = response
					for key in volumeKey
						key = key.is_i? ? key.to_i : key
						if !tmp.nil?
							tmp = tmp[key]
						else
							tmp = -1
							break
						end
					end
					currentEx["volume"] = tmp
				end
			end
		end
		return currentEx
	end
	def getFileContents(file)
		text = File.read(file)
		return text
	rescue Exception => e
		puts e.message
		return -1
	end
	def getCurrent
		for exchange in @jsonData
			puts exchange['name'] + " and " + exchange['currency'] + " and " + exchange['crypto_currency']
			result = getResponse(exchange['api'])
			currentData = {}
			currentData["crypto_curr"] = exchange['crypto_currency']
			currentData["curr"] = exchange['currency']
			currentData["exchange_id"] = exchange['id']
			currentData["success"] = result["success"]
			currentData["buy"] = result["buy"]
			currentData["sell"] = result["sell"]
			currentData["volume"] = result["volume"]
			@result.push(currentData)
		end
	end
	def getResult
		return @result
	end
	def initialize
		@result = []
		path = './exchanges.json'
		@jsonData = JSON.parse(getFileContents(path))
		if @jsonData != -1
			getCurrent
		else
			@result = []
		end
	end
end