class Token < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll

  def validate
    super
    validates_presence :value
    validates_presence :valid_until
  end
end
