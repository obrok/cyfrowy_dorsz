class QuestionCopyOfMigration < Sequel::Migration
  def up
    alter_table :questions do
      add_foreign_key :copy_of_id, :questions, :on_delete => :set_null
    end
  end

  def down
    alter_table :questions do
      drop_column :copy_of_id
    end
  end
end
