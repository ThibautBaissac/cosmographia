class Users::Filter
  def initialize(users:, params:)
    @users = users
    @params = params
  end

  def apply
    query = @params[:user_query]
    query.present? ? @users.search(query) : User.none
  end
end
