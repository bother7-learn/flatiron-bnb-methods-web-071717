class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :checkin, presence:true, if: :check_in_ok?
  validates :checkin, presence:true, if: :before?
  validate :not_same?
  validate :same_day?
  # validate :check_in_ok?

def duration
  x = self.checkout - self.checkin
  x.to_i
end

def total_price
  self.duration * self.listing.price
end

def not_same?
  if self.guest_id == self.listing.host_id
    errors.add(:guest_id, "Guest ID is not valid")
  end
end

def before?
  if checkin && checkout && self.checkin > self.checkout
    errors.add(:check_in, "Checkin is not valid")
  end
end

def same_day?
  if self.checkin == self.checkout
    errors.add(:check_in, "Checkin is not valid")
  end
end

def check_in_ok?
  if checkin && checkout && !self.listing.neighborhood.neighborhood_openings(checkin, checkout).include?(self.listing)
    errors.add(:check_in, "Uh oh")
  end
end
# end


end
