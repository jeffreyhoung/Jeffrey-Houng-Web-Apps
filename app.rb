require 'json'
require "sinatra"
require 'active_support/all'
require "active_support/core_ext"
require 'sinatra/activerecord'
require 'rake'

require 'twilio-ruby'
require 'stock_quote'


configure :development do
  require 'dotenv'
  Dotenv.load
end

#twilio credentials 
account_sid = 'ACb4c91fec26a6011c46aa590ebaef47fb'
auth_token = '7c0cf5d30c155f21636de37de2037dbc'


# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

require_relative './models/list'
require_relative './models/task'

enable :sessions

client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]



get '/' do
  "my ultra great application".to_s
  ENV['TWILIO_NUMBER']
end


get '/send_sms' do
  client.account.messages.create(
  :from => ENV["TWILIO_NUMBER"],
  :to => "+17324037420",
  :body => "Hey There! I just got my web app to work <3"
  )
  "Sent Message"
end


# get '/incoming_sms' do
#
#   session["counter"] ||= 0
#   sms_count = session["counter"]
#
#   sender = params[:From] || ""
#   body = params[:Body] || ""
#
#   if sms_count == 0
#     message = "Welcome! Thanks for the new message!"
#   else
#     message = "Hello! Thanks for the #{sms_count +1} message you've sent today!"
# end
#
#   twilm = Twilio::TwiML::Response.new do |obj|
#     # obj.Message "Thanks for the message! From #{sender} saying #{body}"
#     obj.Message message
#   end
#
#   session["counter"] += 1
#
#   twilm.text
# end
#


get '/incoming_sms' do
  
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  # about, work, fun, beats, experience, and play."
  
  
  if body == "hi" or body == "hello" or body == "hey"
    message = get_about_message + "Want to know a little bit more about me? Try typing:" + get_commands
  elsif body == "about"
    message = get_about_message
  elsif body == "work"
    message = "I was made by Daragh."
  elsif body == "play"
    message = "I don't do much but I do it well. You can ask me who what when where or why."
  elsif body == "beats"    
    message = Time.now.strftime( "It's %A %B %e, %Y")
  elsif body == "work experience"    
    message = "Microsoft: UX Design Intern - May to Aug 2016."
  elsif body == "inspiration"    
    message = "For educational purposes."
  else 
    message = error_response
    session["last_context"] = "error"
  end
  
  # COMMANDS = "about, work, play, beats, and work experience."
  
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message message
  end
  twiml.text
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



error 401 do
  "not allowed!!!"
end



private 

GREETINGS = ["Hey","Yo", "Sup","Hi", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa"]

COMMANDS = "about," + "\n" + " work," "\n" + " play, beats, and work experience."

# # def get_commands
#   error_prompt = ["Sorry, I didn't get that! You can say: ", "Darn! Try asking: "].sample
#
#   return error_prompt + COMMANDS
# end

def get_greeting
  return GREETINGS.sample
end

def get_about_message
  get_greeting + ", I\'m Jeff! Pleasure to have you here!" + "\n" + "I am a senior studying Product Design at Carnegie Mellon University in Pittsburgh, PA!" + "\n" + "It is my last year and it's about to get crazyyyyyy" # + get_commands
end 

def get_help_message
  "You're stuck, eh? " + get_commands
end

def error_response
  error_prompt = ["I didn't catch that.", "Hmmm I don't know that word.", "What did you say to me? "].sample
  error_prompt + " " + get_commands
end

