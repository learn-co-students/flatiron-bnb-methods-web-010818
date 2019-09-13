class City < ActiveRecord::Base
  extend Place::ClassMethods
  include Place::InstanceMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(arrival, departure)
    openings(arrival, departure)
  end

  # def self.highest_ratio_res_to_listings
  #   self.all.max { |c1, c2| c1.res_to_listings <=> c2.res_to_listings }
  # end
  #
  # def res_to_listings
  #   listings.count == 0 ? 0 : reservations_count.to_f / listings.count.to_f
  # end
  #
  # def self.most_res #City with the most total number of reservations
  #   self.all.max { |c1, c2| c1.reservations_count <=> c2.reservations_count }
  # end
  #
  # def reservations_count
  #   listings.count
  #   listings.map { |l| l.reservations.count }.sum
  # end
end
