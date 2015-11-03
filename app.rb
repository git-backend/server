require 'sinatra'
require 'sinatra/cross_origin'
require 'securerandom'
require 'json'
require_relative 'lib/tasks'

enable :cross_origin
set :show_exceptions, false

use Rack::Auth::Basic, 'Restricted' do |user, pass|
  user == ENV['LOGIN_USER'] && pass == ENV['LOGIN_PASS']
end

use Rack::Session::Cookie, key: 'hex', secret: ENV['SECRET']
use Rack::MethodOverride

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] =
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end

configure do
  `git config --global user.name "GitBackend"` if `git config user.name`.empty?
  `git config --global user.email "git-backend@example.com"` if `git config user.email`.empty?
end

before do
  content_type :json
  session[:hex] ||= SecureRandom.hex
end

error do
  err = env['sinatra.error']
  { error: { type: err.class, message: err.message } }.to_json
end

post '/clone' do
  Tasks.clone(session[:hex], ENV['REMOTE_URL'], ENV['REMOTE_BRANCH']).to_json
end

post '/push' do
  Tasks.push(session[:hex], params['message'] || 'GitBackend changes...').to_json
end

get '/ls' do
  Tasks.ls(session[:hex]).to_json
end

get '/read/*' do |path|
  Tasks.read(session[:hex], path).to_json
end

post '/write/*' do |path|
  Tasks.write(session[:hex], path, request.body.read).to_json
end

post '/delete/*' do |path|
  Tasks.delete(session[:hex], path).to_json
end
