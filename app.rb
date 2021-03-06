# frozen_string_literal: true

require 'sinatra'

class DB
  attr_reader :path, :db

  def initialize(path: './hail_the_queen.json')
    @path = path

    unless File.exist?(path)
      File.write(path, { count: 0 }.to_json )
    end

    @db = JSON.parse(File.read(path))
  end

  def count
    db['count']
  end

  def increment_count
    db['count'] += 1
    write!
    db.to_json
  end

  def write!
    File.write(path, db.to_json)
  end
end

$db = DB.new

get '/' do
  erb :index, locals: { count: $db.count }
end

post '/increment' do
  content_type :json
  $db.increment_count
end
