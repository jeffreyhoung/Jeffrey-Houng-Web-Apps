#Experience Prototype

get sms_incoming do
  
  # if incoming number is not in database > get_onboarding
  #elseif get_welcome_back
end 



def get_onboarding
  #go through onboarding if it's the users first time
  #save users phone number in a database as user id
  if body == "hi" or body == "hello" or body == "hey" or body == "yo" or body == "sup" or body == "What's up" or body == "heyo" or body == "hey!"or body == "hi!"
  message = "Hello! How are you? Nutribility at your service!" "I\'m Nutribot! What\'s your name?"
  
  #user enters in their name
  #respond with:
  message = "Thanks" + params[:Name] + "!" + "Nice to meet you! I make cooking a little less stressful for people with dietary needs and people who just want to eat healthier!"
  message = "Do you happen to have any special dietary restrictions that limit your diet? (e.g. high blood pressure, diabetes, high cholestrol, pregnancy)" 
  
  #if user responds with params[:restriction], record restriction in database. (e.g. high cholesterol & blood pressure)
  #respond with: 
  message = "That's good to know! I'll keep in mind that you have" + :Restriction1 + :Restriction2 + "when thinking of recipes for you! You wont have to worry whether you can 'eat soemthing or not' with me!"
  message = "Let's get started!" + get_recipes
  
    
end 


def get_recipes 
  #look at users parameters for restrictions and only select recipes from those columns 
  "Here's a recipe that I found that I think you'll like!" + #sample recipes from e.g. "High Blood Pressure" and "High Cholestrol"
  message = "Japanese Chicken-scallion Rice Bowl: An aromatic, protein rich, broth served over rice." + get_options 
  
  if last_context == 1 or == "Let\'s try this recipe!"
    #respond with: "Awesome! Let's do it! Let's get cooking!"
    #show ingredient list. 
    #if user responds with "Next", move to direction for that recipe at get_directions, if user reponds with a sentence that contains the word "don't" or "out of", add ingredients to database Shopping List and add recipe to Cookbook
    
  elsif last_context == 2 or == "Next, please."
    #sample the recipes in their prospective columns again.
    
  elsif last_context == 3 or == "Save it" or == "Save this recipe for later"
    #save the recipe id in the user database
  
end


def get_options
  "1) Let's try this recipe! \n  2)Next, please. \n 3) Save this recipe for later!"
  
end 



def get_directions
  #respond with first cell in column. If user responds with "next" move down the next cell in the column and send that as a response. 
  #Continue down until second to last cell + "That's it! Hope you enjoyed the recipe! Would you like to save it to your Cookbook?"
  #if user responds with "yes" or "sure" or thumbs up emoji, etc, then add recipeID to user database under cookbook column.
  #reply with "Ok! I've saved it in your cookbook so you know where to find it!" + "Anything else I can do for you today?"
end


def get_grocery_list
  if body == "shopping list"
  #remember last recipe and read out ingredient list of that recipe
end



def get_cookbook
  if body == "cookbook"
    #list all of the recipe id titles that have been saved to user database
end


def get_welcome_back
 # "Welcome back" + params[name associated with user id] + "!" How can I help you today? + 1) Let\'s try a new recipe \n 2) Cookbook \n 3) Shopping List
end 