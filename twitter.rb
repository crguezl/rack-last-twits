# -*- coding: utf-8 -*-
require 'twitter'
require './configure'
require 'rack'
require 'pry-debugger'
require 'thin'
require 'erb'


class Twitts

	puts "#{name}"

	def call env
	    req = Rack::Request.new(env)
	    res = Rack::Response.new 
	   
	    binding.pry if ARGV[0]
	    res['Content-Type'] = 'text/html'

	    
	    name = (req["firstname"] && req["firstname"] != '') ? req["firstname"] : ''

	    puts req["firstname"]
	    ultimo_t = Twitter.user_timeline(name).first.text 
	     

	    
	    puts "#{ultimo_t}"
	    	
		 	 
		number = req["n"] if req["n"]
		
		ultimos_t = Twitter.user_timeline(name,{:count=>number.to_i}) 
		size = ultimos_t.length.to_i - 1 
		i = 0

#cache borrar
	    res.write <<-"EOS"
	      	<!DOCTYPE HTML>
	      	<html>
	      	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	        	<title>Rack::Response</title>
	        	<body>
	          		<h1>
	             		Bienvenido a nuestra aplicación que muestra sus últimos Tweets 
	             	</h1>
	             	<pre>
	             		<form action="/" method="post">
	               			Introduzca su nombre en Twitter: <input type="text" name="firstname"  value="" autofocus><br>
	               			Su último Tweet: #{ultimo_t}

	               			Desea ver más. ¿Cuántos Tweets desea ver? : <input type="text" name="n" value="1"><br>
	               			<input type="submit" value="Submit" >
	             		</form>
	             		
						
	             		Los úlimos Tweets 

				   		for i in (0..size)
	  						#{ultimos_t[i].text}
						end 
	                </pre>
	        	</body>
	      </html>
	    EOS
	    res.finish

	end
end

if $0 == __FILE__
#  	require 'rack'
#  	require 'rack/showexceptions'
	Rack::Server.start(
#    	:app => Rack::ShowExceptions.new(
#            		Rack::Lint.new(
#                		Rack::Twitts.new)), 
		:app => Twitts.new,
	    :Port => 9292,
	    :server => 'thin'
  	)
end
