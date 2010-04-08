class User < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_unique :email
    validates_presence :email
  end
end
