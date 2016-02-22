class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :url

      t.timestamps null: false
    end
  end
end
