require 'digest/sha1'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :polls

  def validate
    super
    validates_unique :email
    validates_presence :email
  end

  SALT = "fdb568c1ee0a925b327826b8c63d75618f40b3a3"
  def randomize_password!
    self.password = self.password_confirmation = Digest::SHA1.hexdigest(SALT + Time.now.to_f.to_s)
    save
  end
end
