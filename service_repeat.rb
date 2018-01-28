require './save_db.rb'

countDay = 0
sumDay = 0
firstEntryTimeDay = ""
countWeek = 0
sumWeek = 0
firstEntryTimeDay = ""
countMonth = 0
sumMonth = 0
firstEntryTimeDay = ""
countAll = 0
sumAll = 0
firstEntryTimeAll = ""

i = 1
while 1
	puts "\n-----------------------*****" + i.to_s + "*****-----------------------"
	i += 1
	SaveDB.new(cou)
	sleep(30)
end