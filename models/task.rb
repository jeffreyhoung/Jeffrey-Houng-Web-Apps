class Task < ActiveRecord::Base
  
  belongs_to :list
  
  validates_presence_of :name
  validates_presence_of :list_id
  
  def to_s
    "#{name} (found in #{list.name})"
  end
  #
  def as_json(options={})
     #{ name: name }
     
     super(:only => [:name])
     
  end
  
end