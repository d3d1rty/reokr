require 'rails_helper'

module Types
  describe '.resolve', type: :request do
    let(:users) { create_list :user, 10 }

    describe 'allUsers' do
      it 'displays a list of users' do
        post graphql_path(query: query), headers: users.first.create_new_auth_token
        response_json = JSON.parse(response.body)['data']['allUsers']
        expect(response_json.length).to eq(users.count)
      end

      it 'displays information for all users' do
        post graphql_path(query: query), headers: users.first.create_new_auth_token
        response_json = JSON.parse(response.body)['data']['allUsers']
        response_json.sort_by! {|usr| usr['id'].to_i }.each_with_index do |user, index|
          expect(user['bio']).to eq(users[index].bio)
          expect(user['email']).to eq(users[index].email)
          expect(user['firstName']).to eq(users[index].first_name)
          expect(user['id']).to eq(users[index].id.to_s)
          expect(user['imageUrl']).to eq(users[index].image_url)
          expect(user['lastName']).to eq(users[index].last_name)
          expect(user['username']).to eq(users[index].username)
        end
      end

      def query
        <<~GQL
          query {
            allUsers {
              id
              email
              firstName
              lastName
              username
              imageUrl
              bio
            }
          }
        GQL
      end
    end

    describe 'showUser' do
      it 'displays information for a given user' do
        post graphql_path(query: query(users.last.id)), headers: users.first.create_new_auth_token
        response_json = JSON.parse(response.body)['data']['showUser']
        expect(response_json['bio']).to eq(users.last.bio)
        expect(response_json['email']).to eq(users.last.email)
        expect(response_json['firstName']).to eq(users.last.first_name)
        expect(response_json['id']).to eq(users.last.id.to_s)
        expect(response_json['imageUrl']).to eq(users.last.image_url)
        expect(response_json['lastName']).to eq(users.last.last_name)
        expect(response_json['username']).to eq(users.last.username)
      end

      def query(user_id)
        <<~GQL
          query {
            showUser(id: #{user_id}){
              id
              email
              firstName
              lastName
              username
              imageUrl
              bio
            }
          }
        GQL
      end
    end
  end
end
