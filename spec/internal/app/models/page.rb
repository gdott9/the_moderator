class Page < ActiveRecord::Base
  has_many :links
  belongs_to :category
end
