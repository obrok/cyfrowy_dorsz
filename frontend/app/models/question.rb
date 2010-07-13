# -*- coding: utf-8 -*-
class Question < Sequel::Model
  plugin :hook_class_methods
  plugin :validation_helpers
  many_to_one :poll
  one_to_many :question_answers

  TYPES = {
    :open => "Otwarte",
    :closed => "Zamknięte",
    :choice => "Wyboru"
  }

  def validate
    super
    
    validates_presence :text, :message => "treść pytania jest wymagana"
    validates_presence :poll
    errors[:question_type] << "niepoprawny typ pytania" unless TYPES.values.include?(question_type)
  end

  def open?
    question_type == TYPES[:open]
  end

  def closed?
    question_type == TYPES[:closed]
  end

  def choice?
    question_type == TYPES[:choice]
  end

  def title
    if text.size>20
      "#{text[0..20]}..."
    else
      text
    end
  end
end
