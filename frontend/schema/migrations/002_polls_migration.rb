class PollsMigration < Sequel::Migration
  def up
    create_table :polls do
      primary_key :id
      Timestamp :date
      String :name
      foreign_key :user_id, :users
    end
  end

  def down
    drop_table :polls
  end
end

