class PollThankyouMigration < Sequel::Migration
  def up
    alter_table :polls do
      add_column :thankyou, String
    end
  end

  def down
    alter_table :polls do
      drop_column :thankyou
    end
  end
end
