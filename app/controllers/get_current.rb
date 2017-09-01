require 'json'

class GetData
	@jsonData
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
					puts exchange['api']
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