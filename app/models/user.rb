class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :visualizations, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_softwares, dependent: :destroy
  has_many :softwares, through: :user_softwares

  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :email, presence: true
  validates :first_name, :last_name, :bio, presence: true, if: :not_guest?
  validate :allowed_social_links_keys

  def fullname
    [ first_name, last_name ].compact.join(" ").presence
  end

  def superadmin?
    superadmin
  end

  def not_guest?
    !guest
  end

  def profile_complete?
    first_name.present? && last_name.present? && bio.present?
  end

  def allowed_social_links_keys
    return if social_links.blank?

    invalid_keys = social_links.keys.map(&:to_s) - Constants::Users::SOCIAL_LINK_KEYS
    if invalid_keys.any?
      errors.add(:social_links, "contains invalid keys: #{invalid_keys.join(', ')}")
    end
  end
end
