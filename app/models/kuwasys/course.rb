class Kuwasys::Course < ActiveRecord::Base
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations, class_name: 'User'
end
