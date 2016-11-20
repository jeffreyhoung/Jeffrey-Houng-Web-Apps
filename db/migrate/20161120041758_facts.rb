class Facts < ActiveRecord::Migration[5.0]
  
  create_table :facts do |t|
    t.integer :Fact_Number 
    t.string :fact 
  end

end
