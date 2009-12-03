class HouseSharing < ActiveRecord::Base
  belongs_to :user
  belongs_to :house
end
