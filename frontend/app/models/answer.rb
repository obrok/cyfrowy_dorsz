class Answer < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll
  one_to_many :question_answer

  def validate
    super
    validates_presence :date
    validates_presence :poll
  end
end
