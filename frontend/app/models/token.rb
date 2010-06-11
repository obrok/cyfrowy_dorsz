class Token < Sequel::Model
  plugin :validation_helpers
  many_to_one :poll

  def validate
    super
    validates_presence :value
    validates_presence :valid_until
  end

  def self.generate_random_value(size = 8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end
end
