class PollMainMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_column :main, TrueClass
    end
  end

  def down
    alter_table :polls do
      drop_column :main
    end
  end
end
