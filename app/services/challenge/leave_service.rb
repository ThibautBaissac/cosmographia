class Challenge::LeaveService
  def initialize(user:, challenge:)
    @user      = user
    @challenge = challenge
  end

  def call
    ActiveRecord::Base.transaction do
      remove_visualizations
      destroy_user_challenge
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def remove_visualizations
    Visualization.where(user: @user, challenge: @challenge)
                 .update_all(challenge_id: nil)
  end

  def destroy_user_challenge
    user_challenge = UserChallenge.find_by!(user: @user, challenge: @challenge)
    user_challenge.destroy!
  end
end
