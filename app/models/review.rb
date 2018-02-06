class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true

  validate :reservation_in_past

  # validations

  def reservation_in_past
    if reservation && reservation.checkout.to_date > Date.today
      errors.add(:base, "Checkout date must be in the past")
    end
  end


end
