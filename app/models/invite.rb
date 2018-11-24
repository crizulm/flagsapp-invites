class Invite < ApplicationRecord
  before_create :generate_token

  validates :email, presence: true
  validates :organization_id, presence: true
  validates :sender_id, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.organization_id, Time.now, rand].join)
  end

end
