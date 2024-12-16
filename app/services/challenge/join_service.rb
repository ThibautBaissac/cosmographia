class Challenge::JoinService
  def initialize(user, challenge)
    @user = user
    @challenge = challenge
  end

  def call
    UserChallenge.find_or_create_by(user: @user, challenge: @challenge)
  end
end
