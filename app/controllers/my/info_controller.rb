class My::InfoController < ApplicationController
  before_action :set_user
  before_action :set_authorize

  def show
  end

  private

  def set_user
    @user = current_user
  end

  def set_authorize
    authorize(@user, policy_class: My::InfoPolicy)
  end
end
