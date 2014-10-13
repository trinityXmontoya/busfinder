require 'sinatra'
require 'sinatra/reloader'
require 'sinatra_more/markup_plugin'
require 'sinatra/cache'
require 'open-uri'
require "nokogiri"
require "mechanize"
require "watir-webdriver"
Dir["./models/*.rb"].each {|file| require file }

set :root, File.dirname(__FILE__)
set :cache_enabled, true
set :cache_output_dir, Proc.new { File.join(root, 'public', 'cache') }
set :cache_environment, :development
set :cache_fragments_output_dir, Proc.new { File.join(root, 'public', 'cache') }

require './routes'
set :server, 'webrick'
set :port, 9494
