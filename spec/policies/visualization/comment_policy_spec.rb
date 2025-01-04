require 'rails_helper'

RSpec.describe Visualization::CommentPolicy do
  subject { described_class.new(user, visualization_comment) }
  let(:visualization) { build(:visualization) }

  context 'when the user is not a guest' do
    let(:user) { build(:user, :not_guest) }
    let(:visualization_comment) { build(:visualization_comment, visualization: visualization) }
    it { is_expected.to permit_only_actions(%i[new create]) }
  end

  context 'when the user is the author of a comment' do
    let(:user) { build(:user, :not_guest) }
    let(:visualization_comment) { build(:visualization_comment, visualization: visualization, user: user) }
    it { is_expected.to permit_only_actions(%i[new create edit update destroy]) }
  end

  context 'when the user is a superadmin' do
    let(:user) { build(:user, :superadmin) }
    let(:visualization_comment) { build(:visualization_comment, visualization: visualization, user: user) }
    it { is_expected.to permit_only_actions(%i[edit update destroy]) }
  end
end
