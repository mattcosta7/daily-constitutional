class CreateUserStars < ActiveRecord::Migration
  def change
    create_table :user_stars do |t|
      t.references :user, index: true, foreign_key: true
      t.references :entry, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
