require './save_db.rb'

i = 0
while i < 10
	SaveDB.new
	i++
	sleep(30)
end