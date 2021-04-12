class House

    ENERGETICS = {
        "A" => 0, "B" => 1, "C" => 2,
        "D" => 3, "E" => 4, "F" => 5,
        "G" => 6
    }

    def self.db
        @db ||= SQLite3::Database.new "./boardimo.db"
        @db.results_as_hash = true
        @db
    end

    def self.all
        db.execute("SELECT * FROM House").map {|row| self.new(row)}
    end

    def self.all_to_h
        # Needs to go through a serializer to format the data
        db.execute("SELECT * FROM House")
    end

    def self.add_houses(data)
        db.execute(
            "INSERT OR IGNORE INTO House VALUES(:link,:name,:description,:city,:surface,:price,:energetics,:year,:fee)",
            data
        )
    end

    attr_reader :data
    def initialize(data)
        @data = data
    end
end