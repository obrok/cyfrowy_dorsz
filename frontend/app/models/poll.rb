# -*- coding: utf-8 -*-
class Poll < Sequel::Model
  TYPES = ['wykład', 'ćwiczenia', 'laboratorium', 'projekt', 'konwersatorium', 'seminarium']

  plugin :validation_helpers
  many_to_one :user
  one_to_many :questions
  one_to_many :tokens
  one_to_many :answers

  def contains_teacher_question
    questions_dataset.filter(:question_type => Question::TYPES[:teacher]).count != 0
  end

  def validate
    super
    validates_presence :name

    errors[:poll_type] << "niepoprawny typ ankiety" unless Poll::TYPES.include?(poll_type)
    errors[:questions] << "tylko jedno pytanie o prowadzącego" if !new? && questions_dataset.filter(:question_type => Question::TYPES[:teacher]).count > 1
  end

  def update_questions_positions(positions={})
    questions = questions_dataset.filter(:id => positions.keys).all
    questions.each do |question|
      question.position = positions[question.id.to_s]
      question.save
    end
  end
end
