# -*- coding: utf-8 -*-
require 'twitter'
require 'sinatra'


require './configure'

get '/' do
  @todo_tweet = []
  @name = ''
  @number = 0		
  erb :twitter
end

post '/' do
  @todo_tweet = []
  client = my_twitter_client() 
  @name = params[:firstname] || ''
  @number = params[:n].to_i
  @number = 1 if @number <= 0
  if client.user? @name 
    ultimos_t = client.user_timeline(@name,{:count=>@number.to_i})
    @todo_tweet =(@todo_tweet != '') ? ultimos_t.map{ |i| i.text} : ''
  end
  erb :twitter
end

