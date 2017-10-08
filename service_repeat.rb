require './save_db.rb'

i = 1
while 1
	puts "\n-----------------------*****" + i.to_s + "*****-----------------------"
	i += 1
	SaveDB.new
	sleep(30)
end