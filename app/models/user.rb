class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  include User::Scopes
  include User::CustomValidations
  include User::Callbacks
  pay_customer default_payment_processor: :stripe, stripe_attributes: :stripe_attributes

  normalizes :slug, with: ->(slug) { slug.strip.downcase }
  normalizes :email, with: ->(email) { email.strip.downcase }

  before_validation :generate_slug, on: [ :create, :update ]

  has_many :visualizations, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :comments, class_name: "Visualization::Comment", dependent: :destroy
  has_many :user_softwares, dependent: :destroy
  has_many :softwares, through: :user_softwares
  has_many :user_challenges, dependent: :destroy
  has_many :challenges, through: :user_challenges
  has_many :subscriptions, class_name: "Billing::Subscription", dependent: :destroy

  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :email, presence: true
  validates :first_name, :last_name, :country_code, presence: true, on: :profile_update
  validates :slug, presence: true, uniqueness: true, exclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :slug, length: {minimum: 4, maximum: 50}, format: {with: /\A[a-z0-9\-_]+\z/, message: :format}
  validate :allowed_social_links_keys
  validates :country_code, inclusion: {in: ISO3166::Country.codes}, on: :profile_update

  accepts_nested_attributes_for :user_softwares, allow_destroy: true

  def fullname
    [ first_name, last_name ].compact.join(" ").presence
  end

  def superadmin?
    superadmin
  end

  def guest?
    first_name.blank? || last_name.blank? || country_code.blank?
  end

  def not_guest?
    !guest?
  end

  def opted_in_directory?
    optin_directory
  end

  def country
    ::ISO3166::Country[country_code]
  end

  def current_subscription
    @current_subscription ||= active_plan_names.find { |plan_name| payment_processor.subscribed?(name: plan_name) }
                                               .then { |plan_name| find_subscription(plan_name) }
  end

  def subscribed?
    @subscribed ||= current_subscription.present?
  end

  def has_remaining_visualizations?
    remaining_visualization_count&.positive?
  end

  def unlimited_visualizations?
    current_plan_version.monthly_visualization_limit.nil?
  end

  def remaining_visualization_count
    return 0 if guest? || !subscribed?
    return Float::INFINITY if current_plan_version.monthly_visualization_limit.nil?

    cycle_start = current_subscription.current_period_start
    cycle_end = current_subscription.current_period_end

    used_visualizations = visualizations.where(
      created_at: cycle_start.beginning_of_day..cycle_end.end_of_day
    ).count

    current_plan_version.monthly_visualization_limit - used_visualizations
  end


  def current_plan_version
    @current_plan_version ||= Billing::PlanVersion.find_by(id: current_subscription&.metadata&.dig("plan_version_id"))
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        country: pay_customer.owner.country.iso_short_name
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }
  end

  private

  def active_plan_names
    @active_plan_names ||= Billing::PlanVersion.active
                                          .joins(:plan)
                                          .pluck("billing_plans.name")
  end

  def find_subscription(plan_name)
    payment_processor.subscriptions.find_by(name: plan_name)
  end
end
