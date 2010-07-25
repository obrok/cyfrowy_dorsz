class Poll < Sequel::Model
  TYPES = ['wykład', 'ćwiczenia', 'laboratorium', 'projekt', 'konwersatorium', 'seminarium']

  plugin :validation_helpers
  many_to_one :user
  one_to_many :questions
  one_to_many :tokens
  one_to_many :answers

  def validate
    super
    validates_presence :name

    errors[:poll_type] << "niepoprawny typ ankiety" unless Poll::TYPES.include?(poll_type)
  end

  def update_questions_positions(positions={})
    questions = questions_dataset.filter(:id => positions.keys)
    questions.each do |question|
      question.position = positions[question.id.to_s]
      question.save
    end
  end
end
