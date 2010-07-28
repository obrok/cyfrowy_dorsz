# -*- coding: utf-8 -*-
class Question < Sequel::Model
  plugin :hook_class_methods
  plugin :validation_helpers
  plugin :serialization, :json, :possible_answers

  many_to_one :poll
  one_to_many :question_answers

  TYPES = {
    :open => "Otwarte",
    :closed => "Zamknięte",
    :choice => "Wyboru",
    :teacher => "Prowadzący"
  }

  def before_save
    if (choice? || teacher?) && possible_answers == nil
      self.possible_answers = []
    end
    super
  end

  def formatted_possible_answers
    if teacher?
      return User.filter(:id => possible_answers).map{|u| Question.user_to_teacher(u)}
    end
    possible_answers
  end

  def selectable_possible_answers
    if teacher?
      User.filter(:id => possible_answers).map{|x| [x.id, Question.user_to_teacher(x)]}
    else
      possible_answers
    end
  end

  def add_possible_answer(value)
    return unless value
    value = value.to_i if teacher?
    possible_answers << value
  end

  def possible_teachers
    return User.filter(~{:id => possible_answers}).map{|u| [u.id, Question.user_to_teacher(u)]}
  end

  def create_question_answer(value)
    qa = QuestionAnswer.new
    qa.question = self
    qa.value = value
    qa
  end

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

  def teacher?
    question_type == TYPES[:teacher]
  end

  def title
    if text.size>20
      "#{text[0..20]}..."
    else
      text
    end
  end

  def self.id_to_teacher(id)
    Question.user_to_teacher(User[:id => id])
  end

  def self.teacher_to_id(value)
    email = value.split.last
    User[:email => email].id
  end

  def self.user_to_teacher(u)
    "#{u.name} #{u.surname} #{u.email}"
  end
end
