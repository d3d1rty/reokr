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

  def self.public_field_names
    %w(first_name last_name username image_url email bio)
  end

  def self.private_field_names
    %w(provider uid encrypted_password reset_password_token reset_password_sent_at allow_password_change
       remember_created_at confirmation_token confirmed_at confirmation_sent_at unconfirmed_email failed_attempts
       unlock_token locked_at sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip
       tokens created_at updated_at)
  end
end
