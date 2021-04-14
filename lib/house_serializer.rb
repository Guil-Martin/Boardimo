class HouseSerializer
    
    ENERGETICS = ["A", "B", "C", "D", "E", "F", "G"]

    FEE = [
        "Le prix indiqué ne comprend pas les honoraires à la charge de l'acheteur",
        "Le prix indiqué comprend les honoraires à la charge de l'acheteur"
    ]

    def to_h
        clean_data
        @data
    end

    def clean_data
        clean_link
        clean_name
        clean_description
        clean_city
        clean_surface
        clean_price
        clean_energetics
        clean_fee
    end

    def clean_link
        
    end

    def clean_name
       
    end

    def clean_description

    end

    def clean_city
        
    end

    def clean_surface
        @data["surface"] = "#{@data["surface"]}m²"
    end

    def clean_price
        @data["price"] = to_euros(@data["price"])
    end

    def clean_energetics
        @data["energetics"] = ENERGETICS[@data["energetics"]]
    end

    def clean_fee
        @data["fee"] = FEE[@data["fee"]]
    end

    def to_euros(num)
        num.to_s.gsub(/\d(?=(...)+$)/, '\0 ') + " €"
    end

    def initialize(house:)
        @data = house
    end

end