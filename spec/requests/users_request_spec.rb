# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /show' do
    let(:user) { create(:user) }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH/PUT /update' do
    let(:user) { create(:user) }

    before(:each) do
      sign_in user
    end

    context 'when signed in' do
      it 'returns http success' do
        patch user_path(user, user: { first_name: Faker::Name.first_name }), headers: user.create_new_auth_token
        expect(response).to have_http_status(:success)
      end
    end

    context 'when signed out' do
      it 'returns http unauthorized' do
        patch user_path(user, user: { first_name: Faker::Name.first_name })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
