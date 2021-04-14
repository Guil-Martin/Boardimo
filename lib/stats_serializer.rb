class StatsSerializer

    def to_h
        clean_data
        @stats
    end

    def clean_data
        clean_price_sqm
        clean_price_sqm_city
        clean_price_sqm_compare
        clean_year_compare
    end

    
    def clean_price_sqm
        @stats["price_sqm"] = to_euros(@stats["price_sqm"])
    end

    def clean_price_sqm_city
        @stats["price_sqm_city"] = to_euros(@stats["price_sqm_city"])
    end

    def clean_price_sqm_compare
        # @stats["price_sqm_compare_positive"] = @stats["price_sqm_compare"] > 100
        # @stats["price_sqm_compare"] = to_percent(@stats["price_sqm_compare"])
    end

    def clean_year_compare
        # @stats["year_compare_positive"] = @stats["year_compare"] > 100
        # @stats["year_compare"] = to_percent(@stats["year_compare"])
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