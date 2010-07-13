class QuestionPossibleAnswersMigration < Sequel::Migration
  def up
    alter_table :questions do
      add_column :possible_answers, String
    end
  end

  def down
    alter_table :questions do
      drop_column :possible_answers
    end
  end
end
