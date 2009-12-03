class House < ActiveRecord::Base
  has_many :house_sharings
  has_many :users, :through => :house_sharings
  has_many :activities
end
