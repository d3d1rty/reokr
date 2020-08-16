module Mutations
  class UpdateUser < BaseMutation
    argument :id, Integer, required: true
    argument :email, String, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :username, String, required: false
    argument :image_url, String, required: false
    argument :bio, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(**attributes)
      user = User.find(attributes[:id])
      raise GraphQL::ExecutionError.new I18n.t('messages.unauthorized') unless user.uid == context[:current_user].uid

      if user.update(attributes)
        { user: user, errors: [] }
      else
        { user: { id: user.id }, errors: user.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new I18n.t('messages.user_not_found', user_id: attributes[:id])
    end
  end
end
