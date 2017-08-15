class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
    User.where(id: self.reservations.select('guest_id').ids)
    # binding.pry
  end

  def hosts
    User.where(id: Listing.select('host_id').where(id: Reservation.select('listing_id').where(guest_id: self.id).ids).ids)
  end

  def host_reviews
    self.reservations.map do |reservation|
      reservation.review
    end  
  end
end
