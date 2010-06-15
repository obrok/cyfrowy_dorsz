class AddTypeToPollMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_column :poll_type, String
    end
  end

  def down
    alter_table :polls do
      drop_column :poll_type
    end
  end
end
