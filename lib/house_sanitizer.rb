class HouseSanitizer
    def initialize(data)
        @data = data
    end

    def to_h

        clean_data
        @data

        # begin
        #     valid
        #     @data
        # rescue => _
        #     {}
        # end        
    end

    private

    # Clean data

    def clean_data
        clean_link
        clean_name
        clean_description
        clean_city
        clean_surface
        clean_price
        clean_energetics
        clean_year
        clean_fee
    end

    def clean_link
        @data[:link]
    end

    def clean_name
        @data[:name]
    end

    def clean_description
        @data[:description].gsub!(/\n/, "<br>")
    end

    def clean_city
        @data[:city] = @data[:city].scan(/vannes|Vannes|séné|Séné|questembert|Questembert|auray|Auray/).first.capitalize
        # @data[:city] = @data[:city].delete("^(vannes|Vannes|séné|Séné|questembert|Questembert|auray|Auray')").capitalize
        
    end

    def clean_surface
        @data[:surface].slice!("m2") if @data[:surface].include?("m2")
        @data[:surface] = @data[:surface].delete("^0-9").to_i    
    end

    def clean_price
        @data[:price] = @data[:price].delete("^0-9")
        # @data[:price].tr(" ", "").split(/(?=[a-z])/).first.to_i
    end

    def clean_energetics
        @data[:energetics] = House::ENERGETICS[@data[:energetics].scan(/[A-G]/).first]
    end

    def clean_year
        @data[:year] = @data[:year].delete("^0-9").to_i
    end

    def clean_fee
        if @data[:fee].include?("ne") && @data[:fee].include?("pas")
            @data[:fee] = 0
        else
            @data[:fee] = 1
        end
    end

    # Eventual errors checks

    def valid_data
        name_safe
        city_safe
        surface_safe
        price_safe
        energetics_safe
        year_safe
        fee_safe
    end
    
    def link_safe

    end

    def name_safe

    end

    def description_safe

    end

    def city_safe

    end

    def surface_safe

    end

    def price_safe

    end

    def energetics_safe
        # IS DIGIT and not a letter
    end

    def year_safe
        current_year = Time.new.year
        # ARE DIGITS AND BETWEEN 1000 AND CURRENT YEAR
    end
    
    def fee_safe

    end

end