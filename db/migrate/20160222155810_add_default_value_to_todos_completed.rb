class AddDefaultValueToTodosCompleted < ActiveRecord::Migration
  def change
    change_column :todos, :is_completed, :boolean, :default => false
  end
end
