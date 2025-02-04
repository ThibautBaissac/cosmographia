class User::InitializeUserSoftwaresService
  def initialize(user)
    @user = user
  end

  def call
    software_ids = Software.order(:name).pluck(:id)

    existing_software_ids = @user.user_softwares.where(software_id: software_ids).pluck(:software_id)

    missing_software_ids = software_ids - existing_software_ids

    missing_software_ids.each do |software_id|
      @user.user_softwares.build(software_id: software_id)
    end
  end
end
