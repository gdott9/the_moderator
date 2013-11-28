class Category < ActiveRecord::Base
  has_one :page
  accepts_nested_attributes_for :page
end
