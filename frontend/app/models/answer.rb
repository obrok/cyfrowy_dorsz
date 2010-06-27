class Answer < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll
  one_to_many :question_answers
  many_to_one :token

  def validate
    super
    validates_presence :date
    validates_presence :poll
    validates_presence :token
  end
end
