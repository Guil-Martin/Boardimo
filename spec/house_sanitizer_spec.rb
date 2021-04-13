require "spec_helper"

# RSpec.describe YachtSanitizer do
        
#     describe "#Check types of data 1" do
#       it "return true if all values are of the right data type " do
  
#         name = "A name"
#         description = "A description"
#         price = "980 000e ht"
#         year = "2020"
#         width = "8.5m"
#         length = "15.3m"
  
#         good_type = true
  
#         data =
#         YachtSanitizer.new(
#           name: name,
#           description: description,
#           price: price,
#           year: year,
#           width: width,
#           length: length,
#         ).to_h
  
#         good_type = data["name"].is_a? String
#         good_type = data["description"].is_a? String
#         good_type = data["condition"].is_a? String
#         good_type = data["price"].is_a? Integer
#         good_type = data["year"].is_a? Integer
#         good_type = data["width"].is_a? Integer
#         good_type = data["length"].is_a? Integer
  
#         expect(good_type).to eql(true)
#       end
  
#       it "return true if all values are of the right data type " do
  
#         name = "Another name"
#         description = "Another description"
#         price = nil
#         year = "0"
#         width = "8.5 m"
#         length = "15.3 m"
  
#         good_type = true
  
#         data =
#         YachtSanitizer.new(
#           name: name,
#           description: description,
#           price: price,
#           year: year,
#           width: width,
#           length: length,
#         ).to_h
  
#         p data
  
#         good_type = data["name"].is_a? String
#         good_type = data["description"].is_a? String
#         good_type = data["condition"].is_a? String
#         good_type = data["price"].is_a? Integer
#         good_type = data["year"].is_a? Integer
#         good_type = data["width"].is_a? Integer
#         good_type = data["length"].is_a? Integer
  
#         expect(good_type).to eql(true)
#       end
  
#     end
  
#   end