class Page < ActiveRecord::Base
  include TheModerator::Model

  has_many :links
  accepts_nested_attributes_for :links

  belongs_to :category
end
