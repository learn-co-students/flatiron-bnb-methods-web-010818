class Review < ActiveRecord::Base
  validates :description, :rating, :reservation_id, presence: true
  validate :reservation_in_past
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def reservation_in_past
    if !reservation_id.nil?
      unless Reservation.find_by(id: reservation_id).in_past?
        self.errors[:reservation_id] << 'Reservation needs to be in the past'
      end
    end
  end
end
