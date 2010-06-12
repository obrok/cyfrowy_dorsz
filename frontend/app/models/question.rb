class Question < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll
  one_to_many :question_answers

  TYPES = ["Otwarte",
           "Zamknięte"]

  def validate
    super
    validates_presence :text
    validates_presence :poll
    errors[:question_type] << "Niepoprawny typ pytania" unless TYPES.include?(question_type)
  end
end
