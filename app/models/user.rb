class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :maps, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_softwares, dependent: :destroy
  has_many :softwares, through: :user_softwares

  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :email, presence: true
  validates :first_name, :last_name, :bio, presence: true, if: :not_guest?

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
end
