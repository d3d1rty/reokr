# frozen_string_literal: true

class UsersController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!, except: :show
  before_action :set_user
  before_action :protect_user_resources, except: :show

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def show
    render json: @user.public_fields, head: :ok
  end

  def update
    @user.update(user_params)
    render json: @user.errors, head: :bad_request unless @user.save

    render json: @user.public_fields, head: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_not_found
    render json: { error: I18n.t('messages.user_not_found', user_id: @user.id) }, head: :not_found
  end

  def protect_user_resources
    render json: { error: I18n.t('messages.unauthorized') }, head: :unauthorized unless @user.uid == current_user.uid
  end

  def user_params
    params.require(:user).permit(%i[first_name last_name username bio image_link])
  end
end
