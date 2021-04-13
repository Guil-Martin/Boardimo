require "spec_helper"
require "pry"

RSpec.describe House do
        
    describe "#Check types of data 1" do
      it "return true if all values are of the right data type" do
  
        link = "https://simply-home-cda.herokuapp.com/15.php"

        not_zero = House::get_price_square_meter_house(link:link)
        p "get_price_square_meter_house - #{not_zero}"  

        not_zero = House::get_average_year
        p "get_average_year - #{not_zero}"
  
        binding.pry

        expect(not_zero).to eql(true)
      end
  

  
    end
  
  end