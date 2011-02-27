class AdminUserMigration < Sequel::Migration
  def up
    alter_table :users do
      add_column :admin, FalseClass
    end
  end

  def down
    alter_table :users do
      drop_column :admin
    end
  end
end
