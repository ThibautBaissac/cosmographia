class Challenge::LeaveService
  def initialize(user, challenge)
    @user = user
    @challenge = challenge
  end

  def call
    ActiveRecord::Base.transaction do
      visualization = Visualization.find_by(user: @user, challenge: @challenge)
      visualization.update!(challenge_id: nil) if visualization.present?
      user_challenge = UserChallenge.find_by(user: @user, challenge: @challenge)
      user_challenge.destroy!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
