require 'rails_helper'

RSpec.describe(Billing::Plan, type: :model) do
  # Test Table Name
  it 'uses the correct table name' do
    expect(Billing::Plan.table_name).to(eq('billing_plans'))
  end

  # Associations
  describe 'associations' do
    it do
      should have_many(:plan_versions)
        .class_name('Billing::PlanVersion')
        .with_foreign_key('billing_plan_id')
        .dependent(:restrict_with_error)
    end
  end

  # Validations
  describe 'validations' do
    subject { build(:billing_plan) } # Ensures uniqueness is tested correctly

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    # Optional: If description has validations, add them here
    # For example, if description is optional:
    it { should allow_value(nil).for(:description) }
    it { should allow_value('A valid description').for(:description) }
  end

  # Scopes
  describe 'scopes' do
    describe '.active' do
      let!(:active_plan) { create(:billing_plan, :active) }
      let!(:inactive_plan) { create(:billing_plan) } # Defaults to active: false

      it 'returns only active plans' do
        expect(Billing::Plan.active).to(include(active_plan))
        expect(Billing::Plan.active).not_to(include(inactive_plan))
      end
    end
  end

  # Default Attribute Values
  describe 'default values' do
    it 'has active set to false by default' do
      plan = build(:billing_plan)
      expect(plan.active).to(be_falsey)
    end
  end

  # Dependent Destruction
  describe 'dependent: :restrict_with_error' do
    let(:plan) { create(:billing_plan) }
    let!(:plan_version) { create(:billing_plan_version, plan: plan) }

    context 'when there are associated plan_versions' do
      it 'does not allow the plan to be destroyed' do
        expect { plan.destroy }.not_to(change(Billing::Plan, :count))
      end
    end

    context 'when there are no associated plan_versions' do
      before { plan_version.destroy }

      it 'allows the plan to be destroyed' do
        expect { plan.destroy }.to(change(Billing::Plan, :count).by(-1))
      end
    end
  end
end
