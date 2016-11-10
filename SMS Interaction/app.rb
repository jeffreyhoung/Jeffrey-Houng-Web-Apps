require "sinatra"
require 'active_support/all'
require "active_support/core_ext"
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'builder'
# require models 
require_relative './models/list'
require_relative './models/task'

# enable sessions for this project

enable :sessions


get "/" do
  #401
  "My Basic Application".to_s
end

#curl -v -H "Accept: application/json, */*" http://localhost:9393/tasks

get '/tasks' do
  @tasks = Task.all
  @tasks.to_json
end
 
get '/tasks/:id' do
  Task.where(id: params['id']).first.to_json
end
 
# curl -X POST -F 'name=test' -F 'list_id=1' http://localhost:9393/tasks
 
post '/tasks' do
  task = Task.new(params)
 
  if task.save
    task.to_json
  else
    halt 422, task.errors.full_messages.to_json
  end
end
 
# curl -X PUT -F 'name=updates' -F 'list_id=1' http://localhost:9393/tasks/1
 
put '/tasks/:id' do
  task = Task.where(id: params['id']).first
 
  if task
    task.name = params['name'] if params.has_key?('name')
    task.is_completed = params['is_completed'] if params.has_key?('is_completed')
    
    if task.save
      task.to_json
    else
      halt 422, task.errors.full_messages.to_json
    end
  end
end
 
delete '/tasks/:id' do
  task = Task.where(id: params['id'])
 
  if task.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end




get '/lists' do
  List.all.to_json(include: :tasks)
end
 
get '/lists/:id' do
  List.where(id: params['id']).first.to_json(include: :tasks)
  
  # my_list = List.where(id: params['id']).first
  # my_list.tasks
  #
  # my_task = Task.where(id: params['id']).first
  # my_task.list
  
  
end
 
post '/lists' do
  list = List.new(params)
 
  if list.save
    list.to_json(include: :tasks)
  else
    halt 422, list.errors.full_messages.to_json
  end
end
 
put '/lists/:id' do
  list = List.where(id: params['id']).first
 
  if list
    list.name = params['name'] if params.has_key?('name')
 
    if list.save
      list.to_json
    else
      halt 422, list.errors.full_messages.to_json
    end
  end
end
 
delete '/lists/:id' do
  list = List.where(id: params['id'])
 
  if list.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end


error 401 do 
  "Not allowed!!!"
end
