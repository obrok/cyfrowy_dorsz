class User < Sequel::Model
  def before_destroy
    super
    polls.each{|x| x.destroy}
  end
end

class Poll < Sequel::Model
  def before_destroy
    super
    questions.each{|x| x.destroy}
    answers.each{|x| x.destroy}
    tokens.each{|x| x.destroy}
  end
end

class Question < Sequel::Model
  def before_destroy
    super
    question_answers.each{|x| x.destroy}
  end
end

class Token < Sequel::Model
  def before_destroy
    super
    answers.each{|x| x.destroy}
  end
end
