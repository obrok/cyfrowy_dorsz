class DropTypeFromTokenMigration < Sequel::Migration
  def up
    alter_table :tokens do
      drop_column :token_type
    end
  end

  def down
    alter_table :tokens do
      add_column :token_type, String
    end
  end
end
