class User::UpdateUserProfileService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      @user.update!(@params)
      @user.update!(guest: false) if @user.profile_complete?
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
