class CreateReaderBlogs < ActiveRecord::Migration
  def change
    create_table :reader_blogs do |t|
      t.references :user, index: true, foreign_key: true
      t.references :blog

      t.timestamps null: false
    end
  end
end
