class Kuwasys::Registration < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :course
  has_one :status
end
