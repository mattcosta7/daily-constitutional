class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :icon
      t.string :conditions
      t.text :text
      t.string :pop
      t.string :high_temp
      t.string :low_temp
      t.references :user, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
