class User::ProfileUpdateService
  Result = Struct.new(:success?, :user)

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @user.assign_attributes(@params)
    if @user.save(context: :profile_update)
      Result.new(true, @user)
    else
      Result.new(false, @user)
    end
  end
end
