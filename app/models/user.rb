class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    reservations.map { |r| r.guest  }
  end

  def reservations
    listings.map { |l| l.reservations }.flatten
  end

  def host_reviews
    guests.map { |g| g.reviews  }.flatten
  end

  def hosts
    trips.map { |t| t.listing.host }
  end
end
