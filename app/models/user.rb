class User < ApplicationRecord
  has_secure_password

  # \A - Start of string
  # (?![0-9]) - Negative lookahead to prevent starting with a digit
  # [a-zA-Z] - Must start with a letter
  # (?:[a-zA-Z0-9]|._)* - Can contain letters, numbers, dots, or underscores, but dots and underscores cannot be consecutive
  # [a-zA-Z0-9] - Must end with a letter or number
  # \z - End of string
  VALID_USERNAME_REGEX = /\A(?![0-9])[a-zA-Z](?:[a-zA-Z0-9]|[._](?![._]))*[a-zA-Z0-9]\z/

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address,
            presence: true,
            uniqueness: true,
            length: { minimum: 5, maximum: 255 },
            format: { with: VALID_EMAIL_REGEX, message: "must be a valid email address" }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 20 },
            format: {
              with: VALID_USERNAME_REGEX,
              message: "can only contain letters, numbers, underscores, and periods, but cannot start with a number or contain consecutive underscores or periods",
            }

  validates :first_name,
            presence: true,
            length: { maximum: 50 }
  validates :last_name,
            presence: true,
            length: { maximum: 50 }

  validates :phone,
            length: { maximum: 15 },
            allow_blank: true
  validates :bio,
            length: { maximum: 1000 },
            allow_blank: true
end
