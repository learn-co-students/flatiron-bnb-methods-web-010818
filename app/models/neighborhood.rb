class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # same as city
  def neighborhood_openings(checkin, checkout)
    openings = []
    self.listings.each do |listing|
      overlaps = listing.reservations.select do |reservation|
        checkin.to_date <= reservation.checkout && checkout.to_date >= reservation.checkin
      end
      if overlaps.empty?
        openings << listing
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    counter = Hash.new
    self.all.each do |location|
      if location.number_of_listings == 0 || location.number_of_listings == 0
        ratio = 0
      else
        ratio = location.number_of_reservations.to_f / location.number_of_listings.to_f
      end
      counter[location] = ratio
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
