class User < ActiveRecord::Base
  has_many :registrations, class_name: 'Kuwasys::Registration',
            dependent: :destroy
  has_many :courses, through: :registrations, class_name: 'Kuwasys::Course'
  has_many :statuses, through: :registrations, class_name: 'Kuwasys:Status'

  accepts_nested_attributes_for :registrations, :allow_destroy => true

  scope :not_registered, -> {
    joins(:registrations).group(:user_id).having('COUNT(users.id) > 1')
  }
  scope :only_registered, -> {
    joins('LEFT JOIN kuwasys_registrations kr ON `users`.`id` = `kr`.`user_id`'
    ).group(:user_id).having('COUNT(users.id) <= 1')
  }
  scope :all_users, -> { # Allow switching to standard-mode again
    all
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
