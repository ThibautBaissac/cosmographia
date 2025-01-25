class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  pay_customer default_payment_processor: :stripe, stripe_attributes: :stripe_attributes

  include User::Associations
  include User::Validations
  include User::Scopes
  include User::SlugGeneration
  include User::SubscriptionHandling

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

  def not_guest_not_subscribed?
    not_guest? && !subscribed?
  end

  def country
    ::ISO3166::Country[country_code]
  end
end
