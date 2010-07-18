require 'digest/sha1'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :polls

  def validate
    super
    validates_unique :email
    validates_presence :email
  end

  SALT = "fdb568c1ee0a925b327826b8c63d75618f40b3a3"
  def randomize_password!
    self.password = self.password_confirmation = random_string
    save
  end

  def reset_password!
    self.login_token = random_string
    randomize_password!
    UserMailer.dispatch_and_deliver(:reset_password,
                                    {:to => email, :subject => "Zmiana hasła w systemie cyfrowy_dorsz"},
                                    {:user => self})
  end

  def ranking

    count = 0
    sum = 0

    polls.each do |poll|
      poll.questions_dataset.where(:question_type => Question::TYPES[:closed]).each do |question|
        count = question.question_answers.count
        sum = sum + question.question_answers.inject(sum) { |sum, n| sum + n.value.to_i }
      end
    end

    return sum.to_f/count.to_f
  end

  private
  def random_string
    Digest::SHA1.hexdigest(SALT + Time.now.to_f.to_s)
  end
end
