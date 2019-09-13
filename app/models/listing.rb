class Listing < ActiveRecord::Base
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  before_save :make_host
  before_destroy :remove_host

  def free?(arrival, departure)
    reservations.select { |r| r.overlap?(arrival, departure)}.empty?
  end

  def make_host
    User.find_by(id: host_id).update(host: true)
  end

  def remove_host
    if Listing.all.select { |l| l.host_id == host_id }.count == 1 ## They have no other listings
      User.find_by(id: host_id).update(host: false)
    end
  end

  def average_review_rating
    total = reviews.map { |r| r.rating }.sum
    total.to_f / reviews.count.to_f
  end
end
