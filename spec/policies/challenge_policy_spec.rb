require 'rails_helper'

RSpec.describe ChallengePolicy do
  subject { described_class.new(user, challenge) }
  let(:challenge) { build(:challenge) }

  context 'with opted in users' do
    let(:user) { build(:user, :optin_directory) }
    it { is_expected.to permit_only_actions(%i[index participations discussion]) }
  end

  context 'with superadmins' do
    let(:user) { build(:user, :superadmin) }
    it { is_expected.to permit_only_actions(%i[index edit new destroy update participations discussion]) }
  end
end
