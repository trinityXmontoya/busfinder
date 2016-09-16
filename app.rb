require 'sinatra'
require 'sinatra_more/markup_plugin'
require 'sinatra/cache'
require 'open-uri'
require "nokogiri"
require "watir-webdriver"
require "sinatra/reloader" if development?
require "pry"
require "httpclient"
Dir["./models/*.rb"].each {|file| require file }

set :root, File.dirname(__FILE__)
set :cache_enabled, true
set :cache_output_dir, Proc.new { File.join(root, 'public', 'cache') }
set :cache_environment, :production
set :cache_fragments_output_dir, Proc.new { File.join(root, 'public', 'cache') }

require './routes'
set :server, 'thin'
