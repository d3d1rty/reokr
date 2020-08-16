# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :email }
    it { should validate_length_of :first_name }
    it { should validate_length_of :last_name }
    it { should validate_length_of :username }
    it { should validate_length_of :image_link }
    it { should validate_length_of :bio }
  end

  context 'database' do
    it { should have_db_column(:provider).of_type(:string) }
    it { should have_db_column(:uid).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:allow_password_change).of_type(:boolean) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:confirmation_token).of_type(:string) }
    it { should have_db_column(:confirmed_at).of_type(:datetime) }
    it { should have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { should have_db_column(:unconfirmed_email).of_type(:string) }
    it { should have_db_column(:failed_attempts).of_type(:integer) }
    it { should have_db_column(:unlock_token).of_type(:string) }
    it { should have_db_column(:locked_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_column(:image_url).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:bio).of_type(:text) }
    it { should have_db_column(:tokens).of_type(:json) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    it { should have_db_index :confirmation_token }
    it { should have_db_index :email }
    it { should have_db_index :reset_password_token }
    it { should have_db_index [:uid, :provider] }
    it { should have_db_index :unlock_token}
    it { should have_db_index :username }
  end
end
