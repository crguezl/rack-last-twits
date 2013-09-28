# -*- coding: utf-8 -*-
require 'twitter'
require './configure'
require 'rack'
require 'pry-debugger'
require 'thin'
require 'erb'



class Twitts

	
	def initialize
		@todo_tweet = []
		@name = ''
		@number = 0		
	end

	def erb(template)
  		template_file = File.open("twitter.html.erb", 'r')
  		ERB.new(File.read(template_file)).result(binding)
	end
	
	def call env
	    req = Rack::Request.new(env)
	    
	    @todo_tweet = []
	    binding.pry if ARGV[0]
	   
	    @name = (req["firstname"] && req["firstname"] != '' && Twitter.user?(req["firstname"]) == true ) ? req["firstname"] : ''

		@number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1
		puts "#{@name}"
		
		if @name == req["firstname"]
			puts "#{@todo_tweet}"
			ultimos_t = Twitter.user_timeline(@name,{:count=>@number.to_i})
			@todo_tweet =(@todo_tweet && @todo_tweet != '') ? ultimos_t.map{ |i| i.text} : ''					
		end

		Rack::Response.new(erb('twitter.html.erb'))
	end

end

if $0 == __FILE__
	Rack::Server.start(
   # 	:app => Rack::ShowExceptions.new(
  #          		Rack::Lint.new(
 #               		Rack::Twitts.new)), 
		:app => Twitts.new,
	    :Port => 9393,
	    :server => 'thin'
  	)
end
