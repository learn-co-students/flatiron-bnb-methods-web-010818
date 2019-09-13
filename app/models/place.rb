module Place

  module InstanceMethods
    def openings(arrival, departure)
      listings.select { |l| l.free?(arrival, departure) }
    end


    def res_to_listings
      listings.count == 0 ? 0 : reservations_count.to_f / listings.count.to_f
    end

    def reservations_count
      listings.map { |l| l.reservations.count }.sum
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      self.all.max { |place1, place2| place1.res_to_listings <=> place2.res_to_listings }
    end

    def most_res #City with the most total number of reservations
      self.all.max { |place1, place2| place1.reservations_count <=> place2.reservations_count }
    end
  end
end
