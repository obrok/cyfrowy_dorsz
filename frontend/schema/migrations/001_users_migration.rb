class UsersMigration < Sequel::Migration
  def up
    create_table :users do
      primary_key :id
      String :email
      String :crypted_password
      String :salt
    end
  end

  def down
    drop_table :users
  end
end
