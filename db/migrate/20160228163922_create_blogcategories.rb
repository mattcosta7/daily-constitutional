class CreateBlogcategories < ActiveRecord::Migration
  def change
    create_table :blogcategories do |t|
      t.references :category, index: true, foreign_key: true
      t.references :blog, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
