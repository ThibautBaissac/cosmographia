require 'rails_helper'

RSpec.describe Billing::PlanVersion, type: :model do
  # Associations
  describe 'associations' do
    it { should belong_to(:plan).class_name('Billing::Plan').with_foreign_key('billing_plan_id') }
    it { should have_many(:subscriptions).class_name('Billing::Subscription').with_foreign_key('billing_plan_version_id').dependent(:restrict_with_error) }
  end

  # Validations
  describe 'validations' do
    subject { create(:billing_plan_version) }

    # version_number validations
    it { should validate_presence_of(:version_number) }
    it { should validate_numericality_of(:version_number).only_integer.is_greater_than(0) }
    it { should validate_uniqueness_of(:version_number).scoped_to(:billing_plan_id) }

    # price_cents validations
    it { should validate_numericality_of(:price_cents).is_greater_than_or_equal_to(0) }

    # monthly_visualization_limit validations
    it { should validate_numericality_of(:monthly_visualization_limit).only_integer.is_greater_than_or_equal_to(0).allow_nil }
  end

  # Scopes
  describe 'scopes' do
    describe '.active' do
      it 'returns only active plan versions' do
        active_plan_version = create(:billing_plan_version, active: true)
        inactive_plan_version = create(:billing_plan_version, active: false)

        expect(Billing::PlanVersion.active).to include(active_plan_version)
        expect(Billing::PlanVersion.active).not_to include(inactive_plan_version)
      end
    end
  end

  # Callbacks
  describe 'callbacks' do
    describe 'before_save :ensure_single_active_version' do
      context 'when activating a plan version' do
        it 'does not deactivate active plan versions of other plans' do
          plan1 = create(:billing_plan)
          plan2 = create(:billing_plan)
          active_version1 = create(:billing_plan_version, plan: plan1, active: true, version_number: 1)
          active_version2 = create(:billing_plan_version, plan: plan2, active: true, version_number: 1)

          new_version = create(:billing_plan_version, plan: plan1, active: false, version_number: 2)
          new_version.update!(active: true)

          active_version1.reload
          active_version2.reload
          new_version.reload

          expect(active_version1.active).to be_falsey
          expect(active_version2.active).to be_truthy
          expect(new_version.active).to be_truthy
        end
      end

      context 'when not activating a plan version' do
        it 'does not change other plan versions' do
          plan = create(:billing_plan)
          active_version = create(:billing_plan_version, plan: plan, active: true, version_number: 1)
          inactive_version = create(:billing_plan_version, plan: plan, active: false, version_number: 2)

          inactive_version.update!(price_cents: 2000) # Trigger before_save without changing active

          active_version.reload
          inactive_version.reload

          expect(active_version.active).to be_truthy
          expect(inactive_version.active).to be_falsey
        end
      end
    end
  end

  # Dependent: restrict_with_error
  describe 'dependent: restrict_with_error' do
    context 'when there are associated subscriptions' do
      it 'prevents deletion and adds an error' do
        plan_version = create(:billing_plan_version)
        create(:billing_subscription, plan_version: plan_version)

        expect(plan_version.destroy).to be_falsey
        expect(plan_version.errors[:base]).to include('Cannot delete record because dependent subscriptions exist')
      end
    end

    context 'when there are no associated subscriptions' do
      it 'allows deletion' do
        plan_version = create(:billing_plan_version)

        expect { plan_version.destroy }.to change { Billing::PlanVersion.count }.by(-1)
      end
    end
  end
end
