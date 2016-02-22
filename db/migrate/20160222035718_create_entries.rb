class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :url
      t.string :author
      t.text :content
      t.datetime :published
      t.references :blog, index: true, foreign_key: true
      t.text :summary
      t.string :categories

      t.timestamps null: false
    end
  end
end
