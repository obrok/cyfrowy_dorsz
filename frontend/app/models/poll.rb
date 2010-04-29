class Poll < Sequel::Model
  plugin :validation_helpers
  many_to_one :user
  one_to_many :questions
  one_to_many :tokens

  def validate
    super
    validates_presence :name
  end
end
