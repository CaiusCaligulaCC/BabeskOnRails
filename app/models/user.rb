class User < ActiveRecord::Base
  has_many :registrations, class_name: 'Kuwasys::Registration',
            dependent: :destroy
  has_many :courses, through: :registrations, class_name: 'Kuwasys::Course'

  accepts_nested_attributes_for :registrations, :allow_destroy => true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
