class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  include User::Scopes
  include User::CustomValidations
  include User::Callbacks

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

  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :email, presence: true
  validates :first_name, :last_name, :country_code, presence: true, if: :not_guest?
  validates :slug, presence: true, uniqueness: true, exclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :slug, length: {minimum: 4, maximum: 50}, format: {with: /\A[a-z0-9\-_]+\z/, message: :format}
  validate :allowed_social_links_keys

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
end
