# -*- coding: utf-8 -*-
class Poll < Sequel::Model
  TYPES = ['wykład', 'ćwiczenia', 'laboratorium', 'projekt', 'konwersatorium', 'seminarium']

  plugin :validation_helpers
  many_to_one :user
  one_to_many :questions
  one_to_many :tokens
  one_to_many :answers
  many_to_one :copy_of, :class => Poll

  def initialize(*args)
    super(*args)
    self.thankyou = "Dziękujemy za wypełnienie ankiety" unless self.thankyou
  end

  def teacher_question
    questions_dataset[:question_type => Question::TYPES[:teacher]]
  end

  def contains_teacher_question?
    !!teacher_question
  end
  
  def answers_for_user(user)
    return unless teacher_question
    answer_ids = QuestionAnswer.
      filter(:question_id => teacher_question.id, :value => user.id.to_s).
      select(:answer_id).map{|x| x.answer_id}.uniq
    Answer.filter(:id => answer_ids)
  end

  def load_question_types
    if self.contains_teacher_question?
      Question::TYPES.values - [Question::TYPES[:teacher]]
    else
      Question::TYPES.values
    end
  end

  def validate
    super
    validates_presence :name
    validates_presence :thankyou
    validates_presence :visible
    validates_presence :blocked
    validates_includes TYPES, :poll_type, :message => "niepoprawny typ ankiety"
  end

  def update_questions_positions(positions={})
    questions = questions_dataset.filter(:id => positions.keys).all
    questions.each do |question|
      question.position = positions[question.id.to_s]
      question.save
    end
  end

  def setup_answers_for_stats(questions, user)
    answers = {}
    questions.each do |question|
      collection = user ? question.question_answers_for_user(user) : question.question_answers
      collection.each do |answer|
        value = answer.value
        unless answers[value]
          answers[value] = {}
        end
        unless answers[value][question]
          answers[value][question] = 0
        end
        answers[value][question] += 1
      end
    end
    answers
  end

  def locked?
    not answers.empty?
  end

  def blocked?
    user.blocked? || blocked
  end

  def main?
    main
  end

  def make_main!
    db.transaction do
      Poll.filter(:main => true).each do |poll|
        poll.update(:main => false)
      end
      self.main = true
      save
    end
  end
  
  def visible?
    !blocked? && visible
  end

  def copy!
    result = nil
    db.transaction do
      result = Poll.create(values.reject{|key, val| [:id, :main].include?(key)})
      for question in questions
        question.copy!(result)
      end
      result.copy_of = self
      result.name = name + " Kopia"
      result.save
    end
    result
  end
end
