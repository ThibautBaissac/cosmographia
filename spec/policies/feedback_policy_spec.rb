require 'rails_helper'

RSpec.describe FeedbackPolicy do
  subject { described_class.new(user, feedback) }
  let(:feedback) { build(:feedback) }

  context 'with signed in users' do
    let(:user) { :user }
    it { is_expected.to permit_only_actions(%i[new create]) }
  end
end
