class Feedback::CreationService
  Result = Struct.new(:success?, :feedback)

  def initialize(user, feedback_params)
    @user = user
    @feedback_params = feedback_params
  end

  def call
    feedback = @user.feedbacks.new(@feedback_params)
    if feedback.save
      Result.new(true, feedback)
    else
      Result.new(false, feedback)
    end
  end
end
