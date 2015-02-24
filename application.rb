require 'net/http'
before do
      content_type :json
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => ['POST']
end

    set :protection, false
    set :public_dir, Proc.new { File.join(root, "_site") }

post '/send_email' do
    url = URI.parse("https://www.google.com/recaptcha/api/siteverify")
req = Net::HTTP::Post.new(url.request_uri)
req.set_form_data({"secret" => settings.private_key_recaptcha, "response" => params[:'g-recaptcha-response']})
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == "https")
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
res = http.request(req)
    resJSON = JSON.parse(res.body)
  if resJSON['success']  
    require 'mandrill'
    m = Mandrill::API.new settings.api_key_mandrill
    template_name = 'freidae-contact-form'
    template_content = [{
     :name => 'email',
     :content => params[:email]
    },
    {
     :name => 'subject',
     :content =>  params[:subject]  
    },
    {
     :name => 'category',
     :content => params[:category]
    },
    {
     :name => 'content',
     :content => params[:content]
    }]
      message = {"to"=>
        [{"email"=>settings.email_mandrill,
            "type"=>"to",
            "name"=>"freidae"}],
     "subject"=>"freidae contact us form"}
      resp=m.messages.send_template template_name, template_content, message
    if resp[0]['status'] == 'sent'
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
