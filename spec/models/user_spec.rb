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

  describe 'public_fields' do
    let(:user) { create(:user) }

    it 'should return a hash' do
      expect(user.public_fields).to be_a(Hash)
    end

    it 'should not return sensitive data' do
      expect(user.public_fields.keys).not_to include(*User.private_field_names)
    end

    it 'should return publicly accessible data' do
      expect(user.public_fields.keys).to include(*User.public_field_names)
    end
  end

  describe 'public_field_names' do
    let(:user) { create(:user) }

    it 'should return an array' do
      expect(User.public_field_names).to be_a(Array)
    end

    it 'should not list private field names' do
      expect(User.public_field_names).not_to include(*User.private_field_names)
    end

    it 'should only list public field names' do
      expect(User.public_field_names).to include(*user.public_fields.keys)
    end
  end

  describe 'private_field_names' do
    let(:user) { create(:user) }

    it 'should return an array' do
      expect(User.private_field_names).to be_a(Array)
    end

    it 'should not list public field names' do
      expect(User.private_field_names).to_not include(*user.public_fields.keys)
    end
  end
end
