require 'sinatra'
require 'sinatra/reloader'
require 'sinatra_more/markup_plugin'
require 'open-uri'
require "nokogiri"
require "mechanize"
require "watir-webdriver"
Dir["./models/*.rb"].each {|file| require file }
require './routes'
set :server, 'webrick'
set :port, 9494
