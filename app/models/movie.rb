class Movie < ActiveRecord::Base
  attr_reader :all_ratings

  def all_ratings
    @all_ratings = ['G','PG','PG-13','R']
  end
end
