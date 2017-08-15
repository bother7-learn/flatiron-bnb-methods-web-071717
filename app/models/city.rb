class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings (date1, date2)
  array1 = date1.split("-")
  array2 = date2.split("-")
  one = Date.new(array1[0].to_i, array1[1].to_i, array1[2].to_i)
  two = Date.new(array2[0].to_i, array2[1].to_i, array2[2].to_i)
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
    res_hash = City.joins(:listings => :reservations).group('cities.name').count('cities.name')
    listing_hash = City.joins(:listings).group('cities.name').count('cities.name')
    ratio_hash = {}
    listing_hash.map do |key, value|
      ratio_hash[key] = res_hash[key].to_f / value.to_f
    end
    check = 0
    most = ""
    ratio_hash.select do |key, value|
      if value > check
        check = value
        most = key
      end
    end
    # binding.pry
    City.find_by(name: most)
  end

  def self.most_res
    hash = City.joins(:listings => :reservations).group('cities.name').count('cities.name')
    check = 0
    most = ""
    hash.select do |key, value|
      if value > check
        check = value
        most = key
      end
    end
    City.find_by(name: most)
  end

end
