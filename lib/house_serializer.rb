class HouseSerializer
    
    ENERGETICS = {
        0 => "A", 1 => "B", 2 => "C",
        3 => "D", 4 => "E", 5 => "F",
        6 => "G"
    }

    def db
        @db ||= SQLite3::Database.new "./boardimo.db"
        @db.results_as_hash = true
        @db
    end

    def to_h

    end

    def to_euros(num)

    end

    def initialize

    end

end