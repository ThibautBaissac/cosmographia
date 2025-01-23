require 'rails_helper'

RSpec.describe(My::ChartsPolicy) do
  let(:record) { build(:user) }


  context 'with the user being the same as the record' do
    let(:user) { record }
    subject { described_class.new(user, record) }

    it { is_expected.to(permit_only_actions(%i[show])) }
  end
end
