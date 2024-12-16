class User::UpdateLastPresenceAtJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    user = User.find(user_id)
    user.update!(last_presence_at: Date.current)
  end
end
