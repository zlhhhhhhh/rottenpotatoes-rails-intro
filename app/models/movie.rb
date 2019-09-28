class Movie < ActiveRecord::Base

  @@all_ratings = ['G','PG','PG-13','R']
  # return the collections to controller
  def self.all_ratings
      @@all_ratings
  end
end
