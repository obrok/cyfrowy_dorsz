class AddBlockedToUserMigration < Sequel::Migration
  def up
    alter_table :users do
      add_column :blocked, :boolean
    end
  end

  def down
    alter_table :users do
      drop_column :blocked
    end
  end
end
