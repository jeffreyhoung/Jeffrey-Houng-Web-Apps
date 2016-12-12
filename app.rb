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

get '/incoming_sms' do
  
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  # about, work, fun, beats, experience, and play."
  
  
  if body == "hi" or body == "hello" or body == "hey" or body == "yo" or body == "sup" or body == "What's up" or body == "heyo" or body == "hey!"or body == "hi!"
    message = get_about_message 
    
  elsif body == "Jeff" or body == "jeff"
      message = get_name

    elsif body == "high blood pressure" or body == "high cholesterol" or body == "I have high blood pressure and high cholesterol" or body == "high blood pressure and high cholesterol"
      message = get_restrictions
      
    elsif body == "ok" or body == "alright" or body == "sure" 
      message = "Here's a recipe that I think would be great for you! Remember, I'm looking out for your HIGH BLOOD PRESSURE needs! \n \n Japanese Chicken-Scallion Rice Bowl: 20 Minutes \n \n An aromatic, protein rich brother served over rice. \n \n" + get_commands
      
      
    elsif body == "1" or body == "Let's try it" or body == "Let's try this recipe!" or body == "let's do it" or body == "I like this one" or body == "this one is fine"
      message = "Jeff's Portfolio: http://jeffreyhoung.com \n LinkedIn Profile: http://linkedin.com/in/jeffreyhoung/ \n E-mail: jhoung@andrew.cmu.edu"  + get_menu
  
        # twiml = Twilio::TwiML::Response.new.do |r|
  #         r. Message do |m|
  #             m.Body message
  #             m.Media pic
  #
    
    elsif body == "2" or body == "next, please" or body == "next" 
        message = "Here's another one! Hope you enjoy it: \n \n" + ["Japanese Shrimp and Eggplant Fried Rice", "Black Bean Croquettes with Fresh Salsa", "Chicken, Mushroom & Wild Rice Casserole", "Banana-Cocoa Soy Smoothie"].sample + "\n \n" + get_commands
    
    elsif body == "3" or body == "save it" or body == "save for later"
      message = "This recipe was saved to your cookbook for future reference!"
    
    else 
      message = error_response
      session["last_context"] = "error"
  end
  
    if body == "Let's talk" or body == "6"  or body == "📞" or body == "lets talk" or body == "let's talk"  
      message = "Do you want to: \n \n 1) shoot the breeze over coffee ☕️ \n 2) Make a work-related inquiry" + get_menu
    end
      
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

COMMANDS = "1) Let's try this recipe!" + "\n" + "2) Next, please." + "\n" + "3) Save this recipe for later!" 
def get_name
  session["last_context"] = "get_name"
  message = "Thanks Jeff! \n \n I make cooking a little less stressful for people with special dietary needs or people who just want to eat healthier! \n \n Do you happen to have any special dietary restrictions that limit your diet? (e.g. high blood pressure, diabetes, current pregnancy, high cholestrol, etc)"

end 

def get_restrictions
  message = "That\'s good to know! I'll keep in mind that you have" + " high blood pressure".upcase + " when thinking of recipes for you! \n \n You won\'t have to worry whether you can eat something or not with me! \n \n Let\'s get started!"
end

def get_menu
  "\n \n Type 'menu' or 'back' at anytime to go back."
end

def get_commands
  error_prompt = ["You can say: \n", "Type one:  \n", "Choose one: \n", "Respond with: \n"].sample

  return error_prompt + COMMANDS
end

def get_greeting
  return GREETINGS.sample
end

def get_about_message
  get_greeting
   message = "Hello! How are you?"
   message = "Nutribility at your service!" 
   "I\'m NutriBot!, What's your name? \n" # + get_commands
end 

def get_help_message
  "You're stuck, eh? " + get_commands
end

def error_response
  error_prompt = ["I didn't catch that.", "Hmmm I don't know that word.", "What did you say to me? "].sample
  error_prompt 
end
