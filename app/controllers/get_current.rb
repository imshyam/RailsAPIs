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
		currentData = Hash['success'=> false, 'buy'=> -1, 'sell'=> -1, 'volume'=> -1]
		if api.length == 1
			url = api['all']['endpoint']
			buy = api['all']['buyKey'].split('.')
			sell = api['all']['sellKey'].split('.')
			volume = api['all']['volumeKey']
			if volume 
				volume = volume.split('.')
			else
				volume = -1
			end
			begin
				response = JSON.parse(open(url, read_timeout: 1, open_timeout: 1).read)
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
			end
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