require 'rails_helper'

module Mutations
  module Users
    describe '.resolve', type: :request do
      let(:user) { create :user }

      it 'updates a user' do
        data_for_update = { user_id: user.id, first_name: Faker::Name.first_name }
        post graphql_path(query: query(data_for_update)), headers: user.create_new_auth_token
        response_json = JSON.parse(response.body)['data']['updateUser']['user']
        expect(response_json['firstName']).to eq(data_for_update[:first_name])
      end

      def query(user_id:, first_name:)
        <<~GQL
          mutation {
            updateUser(
              input: {
                id: #{user_id}
                firstName: \"#{first_name}\"
              }
            ){
              errors
              user {
                id
                email
                firstName
                lastName
                username
                imageUrl
                bio
              }
            }
          }
        GQL
      end
    end
  end
end
