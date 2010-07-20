# -*- coding: utf-8 -*-
class QuestionAnswer < Sequel::Model
  plugin :validation_helpers
  many_to_one :question
  many_to_one :answer

  def validate
    super
    validates_presence :value, :message => 'odpowiedź jest wymagana'
    validates_presence :question
    validates_presence :answer
    validate_answer
  end

  def value=(v)
    if question != nil && question.teacher?
      super Question.teacher_to_id(v)
    else
      super v
    end
  end

  def value
    if question != nil && question.teacher?
      return Question.id_to_teacher(super)
    else
      return super
    end
  end

  private
  def validate_answer
    if question && question.choice? && !question.possible_answers.include?(value)
      errors[:value] << 'musisz wybrać jedną z odpowiedzi'
    end
  end
end
