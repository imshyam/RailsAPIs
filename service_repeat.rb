require './save_db.rb'

i = 0
while i < 2
	SaveDB.new
	i++
	sleep(30)
end