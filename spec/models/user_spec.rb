require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "associations" do
    it { should have_many(:visualizations).dependent(:destroy) }
    it { should have_many(:feedbacks).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:user_softwares).dependent(:destroy) }
    it { should have_many(:softwares).through(:user_softwares) }
    it { should have_many(:user_challenges).dependent(:destroy) }
    it { should have_many(:challenges).through(:user_challenges) }
  end
end
