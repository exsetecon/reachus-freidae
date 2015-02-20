require 'rubygems'
require 'sinatra'
require 'json'
 
configure do
    set :private_key_recaptcha => '6LcLwAATAAAAACTOnf7pIuFZOsvLBe9WrqgrogOQ', :api_key_mandrill => 'KoRD0D6ldDKZrkku18vrXQ', :email_mandrill => 'udbhav1995@gmail.com'
    end
require './application'
run Sinatra::Application