# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :email, presence: true, length: { maximum: 254 }, format: Devise.email_regexp
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :username, length: { maximum: 12 }
  validates :image_url, length: { maximum: 255 }
  validates :bio, length: { maximum: 500 }

  def public_fields
    as_json(only: %i(email first_name last_name username image_url bio))
  end
end
