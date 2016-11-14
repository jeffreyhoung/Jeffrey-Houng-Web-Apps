source 'https://rubygems.org'

gem 'sinatra'
gem 'json'
gem 'shotgun'
gem 'activesupport'


gem "rake"
gem 'activerecord'
gem 'sinatra-activerecord' # excellent gem that ports ActiveRecord for Sinatra
gem 'sinatra-contrib'
gem 'haml'
gem 'builder'


group :development, :test do
  gem 'sqlite3'
end


group :production do
 gem 'pg', '~> 0.19.0'
end

# to avoid installing postgres use 
# bundle install --without production