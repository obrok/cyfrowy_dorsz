class QuestionsMigration < Sequel::Migration
  def up
    create_table :questions do
      primary_key :id
      String :text
      String :question_type
      foreign_key :poll_id, :polls
    end
  end

  def down
    drop_table :questions
  end
end
