class Account < ActiveRecord::Base
  belongs_to :user
  has_many :activities, :through => 'user'
  has_many :houses, :through => 'user'
end
