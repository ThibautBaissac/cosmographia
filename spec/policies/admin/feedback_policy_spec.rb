require 'rails_helper'

RSpec.describe(Admin::FeedbackPolicy) do
  subject { described_class.new(user, feedback) }
  let(:feedback) { build(:feedback) }

  context 'with superadmin' do
    let(:user) { build(:user, :superadmin) }
    it { is_expected.to(permit_only_actions(%i[index])) }
  end
end
