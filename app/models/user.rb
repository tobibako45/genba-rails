class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  # uniqueness: trueでユニークに
  validates :email, presence: true, uniqueness: true

  # UserとTaskの関係は、1対多
  has_many :tasks
end
