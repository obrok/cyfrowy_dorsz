class MultiTokensMigration < Sequel::Migration
  def up
    alter_table :tokens do
      add_column :max_usage, Integer
      add_column :token_type, String
      drop_column :used
    end
    alter_table :answers do
      add_foreign_key :token_id, :tokens
    end
  end

  def down
    alter_table :tokens do
      drop_column :max_usage
      add_column :used, Boolean
      drop_column :token_type
    end
    alter_table :answers do
      drop_foreign_key :token_id, :tokens
    end
  end
end
