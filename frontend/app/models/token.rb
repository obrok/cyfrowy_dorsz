# -*- coding: utf-8 -*-
class Token < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll
  one_to_many :answers

  def validate
    super
    validates_presence :value, :message => "Musisz podać nazwę"
    validates_presence :valid_until 
    validates_presence :poll
    validates_presence :max_usage
    validates_unique :value, :message => "Nazwa musi być unikatowa"     
    errors[:max_usage] << "niepoprawna liczba użyć" if max_usage!=nil and max_usage<1
    errors[:poll] << "Nie można stworzyć tokenów dla ankiety nadrzędnej" if poll && poll.main?
    errors[:admin] << "ankieta admina nie może posiadać tokenów" if poll!=nil && poll.user.admin?
  end

  def self.generate_random_value(size = 8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  def valid_to_use?
    remaining_count>0 && valid_until>DateTime::now && poll.visible?
  end

  def remaining_count
    max_usage-answers.size
  end
end
