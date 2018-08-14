class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.date :date
      t.string :title
      t.string :photo_url
      t.text :content
      t.integer :user_id
    end
  end
end
