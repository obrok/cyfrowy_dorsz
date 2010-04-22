class Poll < Sequel::Model
  plugin :validation_helpers
  many_to_one :user

  def validate
    super
    validates_presence :name
  end
end
