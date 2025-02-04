class Users::Filter
  def initialize(scope: User.all, user_query: nil)
    @scope = scope
    @user_query = user_query
  end

  def apply
    return @scope.none unless @user_query.present?

    @scope.search(@user_query)
  end
end
