class AddBlockedToPollMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_column :blocked, :boolean
    end
  end

  def down
    alter_table :polls do
      drop_column :blocked
    end
  end
end
