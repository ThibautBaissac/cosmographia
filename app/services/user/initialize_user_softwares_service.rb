class User::InitializeUserSoftwaresService
  def initialize(user)
    @user = user
  end

  def call
    Software.order(:name).find_each do |software|
      @user.user_softwares.find_or_initialize_by(software:)
    end
  end
end
