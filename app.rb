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
    message = get_about_message + "\n" + "Want to know a little bit more about Jeff? \n" + get_commands
    
    elsif body == "back" or body == "menu" or body == "home"
      message = get_commands
  
    elsif body == "about" or body == "1"
      message = "🤓 Jeff is a UX & Product Designer, maker, & tinkerer-fueled on curiosity and cortados ☕️. Jeff believes in exposing creativity, magic, and empowerment through the intersection of physical and digital experiences. A lot of motivation from his design comes from the future he wantst to help build from his wife and son. \n \n He\'s currently finishing up his senior year, studying Product Design at Carnegie Mellon University! \ \n \n Jeff is originally from New Jersey, but now calls Pittsburgh home with his wife -  Lydia, and son - Nathan! \n \n Jeff is almost finished up with school, so a full-time job is on his radar." + get_menu
    
    elsif body == "resume" or body == "2"
      message = "As a naturally curious individual, Jeff has explored many different interests that inform his thinking - resulting in envisioning future retail experiences with Microsoft and American Eagle, creating powerful data visualization experiences for SYMKALA, and designing prototypes for connected childrens' toys and sunglasses for local Pittsburgh startups. \n \n 1) Microsoft - UX Design Intern \n \n 2) SYMKALA - Product Designer \n \n 3) BikePGH/PositiveSpin - Cycling Assistant Intern \n \n 4) Transatlantic Climate Bridge - Visual Designer \n \n 5) Look Eyewear - Industrial Design Contractor \n \n 6) AE Dreams - Prototyping Contractor" + " \n \n \n choose number to learn more about each" + get_menu
 
    elsif body == "work" or body == "3"
      # pic = "https://media.licdn.com/mpr/mpr/shrinknp_200_200/AAEAAQAAAAAAAAaDAAAAJDY4ZDI5NWMzLTM1MGQtNDc0NC05Mzk2LWIwZDYxYzQ3ZmYzNA.jpg"
      message = "Jeff's Portfolio: http://jeffreyhoung.com \n LinkedIn Profile: http://linkedin.com/in/jeffreyhoung/ \n E-mail: jhoung@andrew.cmu.edu"  + get_menu
  
        # twiml = Twilio::TwiML::Response.new.do |r|
  #         r. Message do |m|
  #             m.Body message
  #             m.Media pic
  #
    
    elsif body == "random facts" or body == "4" or body == "random"
        message = "Random Fact:" + ["Jeff loves sushi! "] + get_menu
    
    elsif body == "beats" or body == "5"
      message = Time.now.strftime( "It's %A %B %e, %Y") + "currently listening to Chill Tracks Playlist: \n https://open.spotify.com/user/spotify/playlist/6VXeTHZPxzx3SGJvHJj80n" + get_menu
    
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

COMMANDS = "1) about" + "\n" + "2) resume" + "\n" + "3) work" + "\n" + "4) play" + "\n" + "5) beats" + "\n" +  "6) Let's talk! 📞 "

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
  get_greeting + ", I\'m JefferBot, Jeffrey Houng's personal MeBot! 🤖 Pleasure to have you here! \n" # + get_commands
end 

def get_help_message
  "You're stuck, eh? " + get_commands
end

def error_response
  error_prompt = ["I didn't catch that.", "Hmmm I don't know that word.", "What did you say to me? "].sample
  error_prompt + " " + get_commands
end
