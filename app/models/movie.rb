class Movie < ActiveRecord::Base
  belongs_to :user

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.gsub("-", " "))
  end
end
