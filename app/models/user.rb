
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :confirmable
  validates :name, presence: true, length: { minimum: 2 }, uniqueness: true
  validates :email, presence: true, email: true

  before_create do |user|
    user.access_token = user.generate_access_token
  end

  # Generate a unique access_token
  def generate_access_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(access_token: token)
    end
  end

end

