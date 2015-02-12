before do
      puts '[Params]'
      p params
      content_type :json
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => ['POST']
end

    set :protection, false
    set :public_dir, Proc.new { File.join(root, "_site") }

post '/send_email' do
    url = URI.parse("https://www.google.com/recaptcha/api/siteverify")
req = Net::HTTP::Post.new(url.request_uri)
req.set_form_data({"secret" => "6LcLwAATAAAAACTOnf7pIuFZOsvLBe9WrqgrogOQ", "response" => params[:'g-recaptcha-response']})
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == "https")
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    p url.request_uri
    p url.host
    p url.port
    p url.scheme
    p req.body.lines   
res = http.request(req)
  p res.body.lines
    success, errorkey = res.body.lines.map(&:chomp)
    p success
    p errorkey
  if success == 'true'
    uri = URI.parse("http://formspree.io/udbhav1995@gmail.com")
    res = Net::HTTP.post_form(uri, {"email" => params[:inputEmail], "subject" => params[:inputSubject] , "content" => params[:content]})    
    if res
      { :message => 'success' }.to_json
    else
      { :message => 'failure_email' }.to_json
    end
  else
    { :message => 'failure_captcha' }.to_json
  end
end

not_found do
  { :message => 'inside not_found' }.to_json
end

get '/*' do
  file_name = "#{request.path_info}/index.html".gsub(%r{\/+},'/')
  if File.exists?(file_name)
    File.read(file_name)
  else
    raise Sinatra::NotFound
  end
end
