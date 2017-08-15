class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  before_save :make_user_host
  before_destroy :make_host_false

  def average_review_rating
    # binding.pry
    self.reviews.average(:rating).to_f
  end

  private

  def make_user_host
    @user = User.find(self.host_id)
    @user.host = true
    @user.save
  end

  def make_host_false
    @listings = Listing.where(host_id: self.host_id)
    if @listings.length == 1
    @user = User.find(self.host_id)
    @user.host = false
    @user.save
    end
  end



end
