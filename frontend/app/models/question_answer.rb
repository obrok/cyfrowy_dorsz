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
  
  def formatted_value
    question.teacher? ? Question.id_to_teacher(value.to_i) : value
  end

  def validate_without_answer
    validate
    errors.delete(:answer)
  end

  def valid_without_answer?
    validate_without_answer
    errors.size == 0
  end

  private
  def validate_answer
    temp = values[:value]
    temp = temp.to_i if question && question.teacher?
    if question && (question.choice? || question.teacher?) && !question.possible_answers.include?(temp)
      errors[:value] << ' musisz wybrać jedną z odpowiedzi'
    end
  end
end
