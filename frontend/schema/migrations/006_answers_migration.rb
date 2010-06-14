class AnswersMigration < Sequel::Migration
  def up
    create_table :answers do
      primary_key :id
      DateTime :date
      foreign_key :poll_id, :polls
    end

    create_table :question_answers do
      primary_key :id
      String :value
      foreign_key :answer_id, :answers
      foreign_key :question_id, :questions
    end
  end

  def down
    drop_table :question_answers
    drop_table :answers
  end
end
