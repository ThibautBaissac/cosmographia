require 'rails_helper'

RSpec.describe UserPolicy do
  let(:record) { build(:user) }

  context 'with superadmin users' do
    let(:user) { build(:user, :superadmin) }
    subject { described_class.new(user, record) }
    it { is_expected.to permit_only_actions(%i[show edit update]) }
  end

  context 'with the user being the same as the record' do
    let(:user) { record }
    subject { described_class.new(user, record) }

    it { is_expected.to permit_only_actions(%i[show edit update]) }
  end

  context 'with not guest users' do
    let(:user) { build(:user, :not_guest) }
    subject { described_class.new(user, record) }

    it { is_expected.to permit_only_actions(%i[show]) }
  end

  context 'with record having a public_profile' do
    let(:user) { nil }
    let(:record) { build(:user, :public_profile) }
    subject { described_class.new(user, record) }

    it { is_expected.to permit_only_actions(%i[show]) }
  end
end
