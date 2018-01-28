require './save_db.rb'

data = Hash[]

i = 1
while 1
	puts "\n-----------------------*****" + i.to_s + "*****-----------------------"
	puts data
	i += 1
	SaveDB.new(data)
	data = SaveDB.dataAll
	sleep(30)
end