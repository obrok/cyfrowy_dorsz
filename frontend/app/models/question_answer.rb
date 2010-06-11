class QuestionAnswer < Sequel::Model
  plugin :validation_helpers
  many_to_one :question
  many_to_one :answer

  def validate
    super
    validates_presence :value
    validates_presence :question
    validates_presence :answer
  end
end
