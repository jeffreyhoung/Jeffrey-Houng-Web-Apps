class AddIsCompleteToTasks < ActiveRecord::Migration[5.0]
  def change
    
    add_column :tasks, :is_complete, :boolean, default: false
    
  end
end
