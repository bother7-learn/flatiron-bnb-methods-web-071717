class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validates_associated :reservation, if: :allow_validation
  # validates :reservation, presence:true, if: :allow_validation

private
  def allow_validation
    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "Void")
  end
end

end
