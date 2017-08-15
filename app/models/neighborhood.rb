class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings (date1, date2)
  if date1.class == String
  array1 = date1.split("-")
  array2 = date2.split("-")
  one = Date.new(array1[0].to_i, array1[1].to_i, array1[2].to_i)
  two = Date.new(array2[0].to_i, array2[1].to_i, array2[2].to_i)
  # binding.pry
  else
  one = date1
  two = date2
  end
    openings = self.listings.select do |listing|
      x = listing.reservations.map do |reservation|
        (reservation.checkin > one && reservation.checkin < two) ||
        (reservation.checkout > one && reservation.checkout < two) ||
        (reservation.checkin < one && reservation.checkout > two)
      end
        if !x.include?(true)
          listing
        end
      end
  end

  def self.highest_ratio_res_to_listings
    res_hash = Neighborhood.joins(:listings => :reservations).group('neighborhoods.name').count('neighborhoods.name')
    listing_hash = Neighborhood.joins(:listings).group('neighborhoods.name').count('neighborhoods.name')
    ratio_hash = {}
    listing_hash.map do |key, value|
      ratio_hash[key] = res_hash[key].to_f / value.to_f
    end
    check = 0
    most = ""
    ratio_hash.each do |key, value|
      if value > check
        check = value
        most = key
      end
    end
    Neighborhood.find_by(name: most)
  end

  def self.most_res
    hash = Neighborhood.joins(:listings => :reservations).group('neighborhoods.name').count('neighborhoods.name')
    check = 0
    most = ""
    hash.each do |key, value|
      if value > check
        check = value
        most = key
      end
    end
    Neighborhood.find_by(name: most)
  end


end
