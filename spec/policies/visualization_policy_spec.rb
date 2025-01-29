require 'rails_helper'

RSpec.describe(VisualizationPolicy) do
  subject { described_class.new(user, visualization) }
  let(:visualization) { build(:visualization) }

  context 'with superadmin' do
    let(:user) { build(:user, :superadmin) }
    it { is_expected.to(permit_only_actions(%i[index new create show edit update])) }
  end

  context 'with not guest users with remaining visualizations' do
    let(:user) { create(:user, :with_free_subscription) }
    it { is_expected.to(permit_only_actions(%i[index new create show])) }
  end

  context 'with an author of a visualization' do
    let(:user) { build(:user, :superadmin) }
    let(:visualization) { build(:visualization, user: user) }
    it { is_expected.to(permit_only_actions(%i[index new create show edit update])) }
  end
end
