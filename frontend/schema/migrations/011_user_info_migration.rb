class UserInfoMigration < Sequel::Migration
  def up
    alter_table :users do
      add_column :name, String
      add_column :surname, String
    end
  end

  def down
    alter_table :users do
      drop_column :name
      drop_column :surname
    end
  end
end
