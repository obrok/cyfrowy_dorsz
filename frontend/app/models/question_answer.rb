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
    if question != nil && question.teacher? && question.possible_answers.include?(v.to_i)
      super Question.teacher_to_id(v)
    else
      super v
    end
  end

  def value
    v = super

    if question != nil && question.teacher? && question.possible_answers.include?(v.to_i)
      return Question.id_to_teacher(v)
    else
      return v
    end
  end

  private
  def validate_answer
    if question && question.choice? && !question.possible_answers.include?(value)
      errors[:value] << 'musisz wybrać jedną z odpowiedzi'
    end
  end
end
