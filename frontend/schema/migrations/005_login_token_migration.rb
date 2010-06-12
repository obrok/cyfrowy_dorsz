class LoginTokensMigration < Sequel::Migration
  def up
    alter_table :users do
      add_column :login_token, String
      add_index :login_token
    end
  end

  def down
    alter_table :users do
      drop_column :login_token
    end
  end
end
