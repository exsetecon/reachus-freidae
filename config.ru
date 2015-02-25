require 'rubygems'
require 'sinatra'
require 'json'
 
configure do
    set :private_key_recaptcha => '6LcLwAATAAAAACTOnf7pIuFZOsvLBe9WrqgrogOQ',
        :google_recaptcha_server => "https://www.google.com/recaptcha/api/siteverify",
        :api_key_mandrill => 'KoRD0D6ldDKZrkku18vrXQ', 
        :email_mandrill => 'udbhav1995@gmail.com',
        :tag_mandrill => 'freidae-contact-form',
        :subject_message_mandrill => "freidae contact us form"
    end
require './application'
run Sinatra::Application