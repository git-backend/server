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
  session[:hex] ||= SecureRandom.hex
end

error do
  content_type :json
  err = env['sinatra.error']
  { error: { type: err.class, message: err.message } }.to_json
end

post '/clone' do
  content_type :json
  files = Tasks.clone(session[:hex], ENV['REMOTE_URL'], ENV['REMOTE_BRANCH'])
  { files: files }.to_json
end

post '/push' do
  Tasks.push(session[:hex], params['message'] || 'GitBackend changes...')
  200
end

get '/ls' do
  content_type :json
  files = Tasks.ls(session[:hex])
  { files: files }.to_json
end

get '/read/*' do |path|
  content_type :json
  content = Tasks.read(session[:hex], path)
  { content: content }.to_json
end

post '/write/*' do |path|
  Tasks.write(session[:hex], path, request.body.read)
  200
end

post '/delete/*' do |path|
  Tasks.delete(session[:hex], path)
  200
end
