class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # validations
  validates :checkin, :checkout, presence: true
  validate :host_not_match_guest
  validate :dates_are_available
  validate :checkin_before_checkout

  def duration
    (checkout-checkin).to_i
    # gives number of days of reservation
  end

  def total_price
    self.listing.price.to_f * duration
    # returns price using duration and price per day
  end

  def host_not_match_guest
    if guest == listing.host
      errors.add(:guest, "Guest cannot match host")
    end
  end

  def dates_are_available
    if checkin && checkout
      overlaps = listing.reservations.select do |reservation|
        checkin.to_date <= reservation.checkout && checkout.to_date >= reservation.checkin
      end
      if !overlaps.empty?
        errors.add(:checkin, "Not available on those dates")
        errors.add(:checkout, "Not available on those dates")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if checkin.to_date >= checkout.to_date
        errors.add(:checkin, "must be before checkout")
        errors.add(:checkout, "must be after checkin")
      end
    end
  end

end
