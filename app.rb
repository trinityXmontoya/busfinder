require 'sinatra'
require 'sinatra/reloader'
require 'sinatra_more/markup_plugin'
require 'open-uri'
require "nokogiri"
require "mechanize"
require "watir-webdriver"
require './search'
require './routes'
also_reload './search'
set :server, 'webrick'
set :port, 9494
