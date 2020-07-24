require 'rack'
require 'rack/contrib'
require 'sinatra'
require 'pry'
require './app/util'
require './app/move'
require './app/board'
require './app/snake'
Dir['./app/snake/*.rb'].sort.each { |file| require file }

use Rack::PostBodyContentTypeParser

# If you open your Battlesnake URL in a browser you should see this message.
get '/' do
  "Your Battlesnake is alive!\n"
end

# The Battlesnake engine calls this function to make sure your Battlesnake is working.
post '/ping' do
  "pong\n"
end

# This function is called everytime your Battlesnake is entered into a game.
# request contains information about the game that is about to be played.
# TODO: Use this function to decide how your Battlesnake is going to look on the board.
post '/start' do
  request = underscore(env['rack.request.form_hash'])
  puts "START"
  content_type :json

  appearance = {
    color: "#4AF626",
    head_type: "shac-tiger-king",
    tail_type: "shac-tiger-tail",
  }

  camelcase(appearance).to_json
end

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
post '/move' do
  request = underscore(env['rack.request.form_hash'])

  board = Board.new(request[:board])

  # Get random snake subclass
  class_name = snake_classes.sample + "Snake"
  snake_class = Object.const_get(class_name)
  snake = snake_class.new(player: request[:you], board: board)
  puts "Initialized: #{snake.class}"

  # Implement move logic in app/move.rb
  response = snake.move
  content_type :json
  camelcase(response).to_json
end

# This function is called when a game your Battlesnake was in ends.
# It's purely for informational purposes, you don't have to make any decisions here.
post '/end' do
  puts "END"
  "ok\n"
end

def snake_classes
  ["", "Growth"]
end