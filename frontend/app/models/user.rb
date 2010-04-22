class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :polls

  def validate
    super
    validates_unique :email
    validates_presence :email
  end
end
