class GetCurrent
	def getFileContents(file)
		text = File.read(file)
		return text
	rescue Exception => e
		puts e.message
		return -1
	end

	def initialize
		path = './../../exchanges.json'
		puts getFileContents(path)
	end
end

GetCurrent.new