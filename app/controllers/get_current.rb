require 'json'
require 'open-uri'

class GetData
	@jsonData
	def getResponse(api)
		if api.length == 1
			puts api
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
				CurrentData::success = false
			else
				puts response
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