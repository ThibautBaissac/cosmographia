class Challenge::LeaveService
  def initialize(user, challenge)
    @user = user
    @challenge = challenge
  end

  def call
    ActiveRecord::Base.transaction do
      Visualization.where(user: @user, challenge: @challenge).update_all(challenge_id: nil)
      user_challenge = UserChallenge.find_by(user: @user, challenge: @challenge)
      user_challenge.destroy!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
