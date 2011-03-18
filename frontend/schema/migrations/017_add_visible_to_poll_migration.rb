class AddVisibleToPollMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_column :visible, :boolean
    end
  end

  def down
    alter_table :polls do
      drop_column :visible
    end
  end
end
