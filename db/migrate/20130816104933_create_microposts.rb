class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    # we expect to retrieve microposts associated with a given user in reverse order of creation
    # including both columns as an array creates a 'multiple key index' -> ActiveRecord uses BOTH keys at same time
  end
end
