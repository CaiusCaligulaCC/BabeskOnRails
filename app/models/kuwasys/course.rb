class Kuwasys::Course < ActiveRecord::Base
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations, class_name: 'User'
  has_many :statuses, through: :registrations

  scope :has_registrations_with_status, -> (status_name) {
    joins(:registrations).joins(
        'LEFT JOIN `kuwasys_statuses` ON
          `kuwasys_registrations`.`status_id` = `kuwasys_statuses`.`id`'
      ).where('`kuwasys_statuses`.`name` = ?', status_name)
      .group('`kuwasys_courses`.`id`')
      .having('COUNT(`kuwasys_courses`.`id`) >= 1')
  }
end
