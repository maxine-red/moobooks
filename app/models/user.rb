class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :level, inclusion: { in: %w(user mooderator admin),
                                 message: "%{value} is not a valid user level" }
end
