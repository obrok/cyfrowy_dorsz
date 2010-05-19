class TokensMigration < Sequel::Migration
  def up
    create_table :tokens do
      primary_key :id
      String :value
      foreign_key :poll_id, :polls
      Date :valid_until
      bool :used
    end
  end

  def down
    drop_table :tokens
  end
end
