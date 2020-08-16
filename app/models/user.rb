# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :email, uniqueness: true, presence: true, length: { maximum: 254 }, format: Devise.email_regexp
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :username, uniqueness: true, allow_nil: true, length: { maximum: 12 }
  validates :image_url, length: { maximum: 255 }
  validates :bio, length: { maximum: 500 }
end
