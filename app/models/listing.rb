class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, :address, :neighborhood, :listing_type, :description, :price, :neighborhood_id, presence: true

  before_create :set_host
  before_destroy :remove_host

  def average_review_rating
    reviews.average(:rating).to_f
  end

  private

  def set_host
    host.update(host:true)
  end

  def remove_host
    if host.listings.size == 1
      host.update(host:false)
    end
  end
end
