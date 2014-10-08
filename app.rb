require 'sinatra'
require 'sinatra/reloader'
require 'sinatra_more/markup_plugin'
require 'open-uri'
require "nokogiri"
require "mechanize"
require './search'
require './routes'

set :server, 'webrick'
set :port, 9494
