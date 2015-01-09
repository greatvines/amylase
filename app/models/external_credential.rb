class ExternalCredential < ActiveRecord::Base
  nilify_blanks

  validates_presence_of :name
  validates_uniqueness_of :name


  # Override the setter to encrypt the password.
  def password=(value)
    value.blank? ? nil : write_attribute(:password, crypt.encrypt(value))
  end

  # Override the getter to decrypt the password.
  def password
    raw_password = read_attribute(:password)
    raw_password.blank? ? nil : crypt.decrypt(raw_password)
  end

  private

  def crypt
    Envcrypt::Envcrypter.new
  end
end
