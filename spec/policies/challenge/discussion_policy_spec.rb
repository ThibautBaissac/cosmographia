require 'rails_helper'

RSpec.describe(Challenge::DiscussionPolicy) do
  let(:challenge) { create(:challenge, :with_users) }
  let(:user) { challenge.users.first }
  let(:superadmin) { create(:user, :superadmin) }
  let(:challenge_discussion) { create(:challenge_discussion, challenge: challenge, user: user) }

  context 'when the user is part of the challenge' do
    subject { described_class.new(user, challenge_discussion) }
    it { is_expected.to(permit_only_actions(%i[new create edit update destroy])) }
  end

  context 'when the user is a superadmin' do
    subject { described_class.new(superadmin, challenge_discussion) }
    it { is_expected.to(permit_only_actions(%i[edit update destroy])) }
  end
end
