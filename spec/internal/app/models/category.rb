class Category < ActiveRecord::Base
  include TheModerator::Model

  has_one :page
  accepts_nested_attributes_for :page
end
