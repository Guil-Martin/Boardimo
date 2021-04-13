require "pry"
require "json"
require "sqlite3"
require "./lib/house"
require "./lib/house_sanitizer"

link = "simply-home.herokuapp.com/house10.php"

price_square = House::get_price_square_meter_house(link)
p "get_price_square_meter_house - #{price_square}"  

avg_year = House::get_average_year
p "get_average_year - #{avg_year}"

avg_energetics = House::get_average_energetics
p "get_average_energetics - #{avg_energetics}"

avg_price_city = House::get_price_square_meter_city("Séné")
p "get_price_square_meter_city Séné - #{avg_price_city}"

avg_price_city = House::get_price_square_meter_city("Vannes")
p "get_price_square_meter_city Vannes - #{avg_price_city}"

avg_price_city = House::get_price_square_meter_city("Questembert")
p "get_price_square_meter_city Questembert - #{avg_price_city}"

avg_price_city = House::get_price_square_meter_city("Auray")
p "get_price_square_meter_city Auray - #{avg_price_city}"

percent_square = House::compare_price_square_meter(link)
p "compare_price_square_meter - #{percent_square}"


# stuff = {link: "dsgfdfg", img: "fsfsdf", description: "dessdsdsd", name: "NAME",
#     cityName: "daname city", surface: 456, price: 121212,
#     energetics: 3, year: 1985, fee: 1}
# p stuff



house = House::get_by_link(link)
p house

p "house.data[city] - #{house.data["cityName"]}"

price_sm_city = House::get_price_square_meter_city(house.data["cityName"])
p "price_sm_city - #{price_sm_city}"

price_sqm_compare = House::compare_price_square_meter(house)
p "price_sqm_compare - #{price_sqm_compare}"

compare_year = House::compare_year(house)
p "compare_year OBJ House - #{compare_year}"

compare_year = House::compare_year(link)
p "compare_year by link - #{compare_year}"

# binding.pry