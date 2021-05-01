require 'rack'
require 'rack/contrib'
require 'sinatra'
require 'pry'
require './app/util'
require './app/move'
require './app/board'
require './app/game'
require './app/snake'
Dir['./app/snake/*.rb'].sort.each { |file| require file }

use Rack::PostBodyContentTypeParser

$games = {}
$snake_class

# If you open your Battlesnake URL in a browser you should see this message.
get '/' do
  {
    apiversion: "1",
    author: "ifellinaholeonce",
    color: "#4AF626",
    head: "shac-tiger-king",
    tail: "shac-tiger-tail"
  }
end

# This function is called everytime your Battlesnake is entered into a game.
# request contains information about the game that is about to be played.
# TODO: Use this function to decide how your Battlesnake is going to look on the board.
post '/start' do
  request = underscore(env['rack.request.form_hash'])
  puts "START"
  content_type :json

  game = Game.new(id: request[:game][:id])
  game.board = Board.new(board: request[:board], game: game)
  game.snake = create_snake(request, game.board, game)

  $games[game.id] = game
  true
end

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
post '/move' do
  request = underscore(env['rack.request.form_hash'])
puts request
  game = $games[request[:game][:id]]
  game.tick(request)
  snake = game.snake

  # Implement move logic in app/move.rb
  response = snake.move
  content_type :json
  camelcase(response).to_json
end

# This function is called when a game your Battlesnake was in ends.
# It's purely for informational purposes, you don't have to make any decisions here.
post '/end' do
  request = underscore(env['rack.request.form_hash'])

  puts "END"
  puts request
  # Maybe win/loss should leave on the Game and then once
  # the game is completed we save it to DB and remove from
  # memory.
  if request[:board][:snakes].length == 1 && request[:board][:snakes].first[:id] == request[:you][:id]
    # TODO: Save this to a DB to analyze
    puts "Victory"
  else
    # TODO: Try and determine reason
    puts "We lost"
  end
  $games.delete(request[:game][:id])
  "ok\n"
end

def snake_classes
  ["Growth"]
end

def choose_a_snake
  $snake_class = snake_classes.sample + "Snake"
end

def create_snake(request, board, game)
  choose_a_snake
  # Get random snake subclass
  class_name = Object.const_get($snake_class)
  snake = class_name.new(player: request[:you], board: board, game: game)
  puts "Initialized: #{snake.class}"
  snake
end
