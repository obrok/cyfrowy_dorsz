class PollCopyOfMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_foreign_key :copy_of_id, :polls, :on_delete => :set_null
    end
  end

  def down
    alter_table :polls do
      drop_column :copy_of_id
    end
  end
end
