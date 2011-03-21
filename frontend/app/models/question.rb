# -*- coding: utf-8 -*-
class Question < Sequel::Model
  plugin :hook_class_methods
  plugin :validation_helpers
  plugin :serialization, :json, :possible_answers

  many_to_one :poll
  one_to_many :question_answers
  many_to_one :copy_of, :class => Question

  attr_accessor :possible_answer, :teacher

  TYPES = {
    :open => "Otwarte",
    :closed => "Zamknięte",
    :choice => "Wyboru",
    :teacher => "Prowadzący"
  }

  def before_validation
    if (choice? || teacher?) && possible_answers.blank?
      self.possible_answers = []
      if choice? && !possible_answer.blank?
        self.add_possible_answer(possible_answer)
        self.possible_answer = nil
      elsif teacher? && !teacher.blank?
        self.add_possible_answer(teacher)
        self.teacher = nil
      end
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
    if errors.empty?
      User.filter(~{:id => possible_answers}).map{|u| [u.id, Question.user_to_teacher(u)]}
    else
      User.map{|u| [u.id, Question.user_to_teacher(u)]}
    end
  end

  def create_question_answer(value)
    qa = QuestionAnswer.new
    qa.question = self
    qa.value = value
    qa
  end
  
  def question_answers_for_user(user)
    answer_ids = poll.answers_for_user(user).map{|x| x.id}
    return question_answers_dataset.filter(:answer_id => answer_ids)
  end

  def question_type=(value)
    self.possible_answers = [] unless (value == TYPES[:choice] || value == TYPES[:teacher])
    super(value)
  end

  def validate
    super
    validates_unique [:poll_id, :text], :message => "Pytanie o takiej nazwie już istnieje"
    validates_unique([:question_type], :message => "Istnieje juz pytanie o prowadzacego") { |ds| ds.filter(:question_type => TYPES[:teacher]).filter(:poll_id => poll_id) }
    validates_presence :text, :message => "treść pytania jest wymagana"
    validates_presence :poll
    validates_includes TYPES.values, :question_type, :message => "niepoprawny typ pytania"
    errors[:possible_answer] << "Wymagana przynajmniej jedna mozliwa odpowiedz" if choice? && (possible_answers.blank? || possible_answers.empty?)
    errors[:possible_answer] << "Mozliwa opowiedz nie moze byc pusta" if choice? && (!possible_answers.blank? && possible_answers.any?(&:blank?))
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

  def locked?
    not question_answers.empty?
  end

  def can_change_choice?
    !(choice? && !possible_answers.empty? || teacher? && !possible_teachers.empty?)
  end

  def can_delete_possible_answer?
    possible_answers.size > 1
  end

  def load_question_types
    if teacher?
      return TYPES.values
    else
      return poll.load_question_types
    end
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
  
  def copy!(poll)
    result = Question.new(values.reject{|key, val| key == :id})
    result.possible_answers = possible_answers
    result.poll = poll
    result.copy_of = self
    result.save
  end
end
