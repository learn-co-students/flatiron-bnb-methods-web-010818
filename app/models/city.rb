class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    openings = []
    neighborhoods.each do |neighborhood|
      openings << neighborhood.neighborhood_openings(checkin,checkout)
    end
    openings.flatten
  end

  def self.highest_ratio_res_to_listings
    counter = Hash.new
    self.all.each do |city|
      if city.number_of_listings == 0 || city.number_of_listings == 0
        ratio = 0
      else
        ratio = city.number_of_reservations.to_f / city.number_of_listings.to_f
      end
      counter[city] = ratio
    end
    self.return_max(counter)
  end

  def self.most_res
    # return city with most total reservations
    counter = Hash.new
    self.all.each do |city|
      counter[city] = city.number_of_reservations
    end
    self.return_max(counter)
  end

  def number_of_reservations
    self.listings.collect do |listing|
      listing.reservations
    end.flatten.size
  end

  def number_of_listings
    self.listings.size
  end

  def self.return_max(counter_hash)
    counter_hash.find {|key, value| counter_hash.values.max == value}.first
  end

end
