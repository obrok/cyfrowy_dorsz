class AddPositionToQuestionsMigration < Sequel::Migration
  def up
    alter_table :questions do
      add_column :position, Integer
    end
  end

  def down
    alter_table :questions do
      drop_column :position
    end
  end
end
