class Movie < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :summary, :star_rating, :user_id

end
