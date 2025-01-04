require 'rails_helper'

RSpec.describe SourcePolicy do
  subject { described_class.new(user, source) }
  let(:source) { build(:source) }

  context 'with opted in users' do
    let(:user) { build(:user, :optin_directory) }
    it { is_expected.to permit_only_actions(%i[index new create edit update]) }
  end

  context 'with superadmins' do
    let(:user) { build(:user, :superadmin) }
    it { is_expected.to permit_only_actions(%i[index new create edit update destroy]) }
  end
end
