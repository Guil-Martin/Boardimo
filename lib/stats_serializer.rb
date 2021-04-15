class StatsSerializer

    def to_h
        clean_data
        @stats
    end

    def clean_data
        clean_price_sqm
        clean_price_sqm_city
        clean_price_sqm_compare     
    end

    
    def clean_price_sqm
        @stats["price_sqm_raw"] = @stats["price_sqm"]
        @stats["price_sqm"] = to_euros(@stats["price_sqm"])
    end

    def clean_price_sqm_city        
        @stats["price_sqm_city_raw"] = @stats["price_sqm_city"],
        @stats["price_sqm_city"] = to_euros(@stats["price_sqm_city"])
    end

    def clean_price_sqm_compare
        @stats["price_sqm_compare_raw"] = @stats["price_sqm_compare"]
        @stats["price_sqm_compare"] = to_percent(@stats["price_sqm_compare"])
    end

    private

    ##Utilities
    def to_euros(num)
        num.to_s.gsub(/\d(?=(...)+$)/, '\0 ') + " €"
    end

    def to_percent(num)
        if num > 100
            num - 100
        else
            -(num -100)
        end
    end

    def initialize(stats:)
        @stats = stats
    end

end