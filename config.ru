require 'rubygems'
require 'sinatra'
require 'json'
require 'rack/recaptcha'

use Rack::Recaptcha, :public_key => '6LcLwAATAAAAAI1ssN3BesuD7qwOKtV7Dg227-tv', :private_key => '6LcLwAATAAAAACTOnf7pIuFZOsvLBe9WrqgrogOQ'
helpers Rack::Recaptcha::Helpers

require './application'
run Sinatra::Application