class Neighborhood < ActiveRecord::Base
  extend Place::ClassMethods
  include Place::InstanceMethods
  belongs_to :city
  has_many :listings

  def neighborhood_openings(arrival, departure)
    openings(arrival, departure)
  end
end
