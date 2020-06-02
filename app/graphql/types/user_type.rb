module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :username, String, null: true
    field :image_url, String, null: true
    field :bio, String, null: true

    field :all_users, [UserType], null: false
    field :show_user, UserType, null: false do
      argument :id, ID, required: true
    end

    def all_users
      User.all
    end

    def show_user(id:)
      User.find(id)
    end
  end
end
