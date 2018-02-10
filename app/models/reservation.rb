class Reservation < ActiveRecord::Base
  validate :host_not_same_as_guest
  validate :valid_checkin_and_checkout
  validate :checkin_before_checkout
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def overlap?(arrival, departure)
    #first check that start < end and if they're not, swap them
    arrival < departure || (arrival, departure = departure, arrival)
    #verify the reservation instances checkin is less than checkout, otherwise swap them
    end_date = DateTime.parse(checkout) if checkout.is_a? String

    arrival = DateTime.parse(arrival) if arrival.is_a? String
    departure = DateTime.parse(departure) if departure.is_a? String

    if arrival < checkin && departure < checkin
      false
    elsif arrival > checkout && departure > checkout
      false
    elsif arrival <= checkin && departure >= checkout
      true
    elsif arrival >= checkin && arrival <= checkout
      true
    elsif departure >= checkin && departure <= checkout
      true
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  def in_past?
    checkout < DateTime.now
  end

  def checkin_before_checkout
    if !checkin.nil? && !checkout.nil?
      unless checkin < checkout
        self.errors[:checkin] << 'Checkin needs to be before checkout'
      end
    end
  end

  def valid_checkin_and_checkout
    unless !checkin.nil? && !checkout.nil?
      self.errors[:checkin] << 'Checkin or Checkout cannot be empty'
    end
    ## Can only do further validation if neither checkin nor checkout are non-nil
    if !checkin.nil? && !checkout.nil?
      unless listing.free?(checkin, checkout)
        self.errors[:checkin] << 'Conflicts with existing reservation'
      end

      unless checkin != checkout
        self.errors[:checkin] << 'Checkin and Checkout cannot be the same day'
      end
    end
  end

  def host_not_same_as_guest
    unless listing.host_id != guest_id
      self.errors[:host_id] << 'The host cannot make a reservation on their own listing'
    end
  end
end
