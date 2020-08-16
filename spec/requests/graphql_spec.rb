require 'rails_helper'

describe GraphqlController, type: :request do
  let(:user) { create :user }

  it_behaves_like 'an endpoint that requires authentication', :post, :graphql_path
end
