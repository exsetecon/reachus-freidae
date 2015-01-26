before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['POST']
end

set :protection, false
set :public_dir, Proc.new { File.join(root, "_site") }

post '/send_email' do
  if recaptcha_valid?
    uri = URI.parse("http://formspree.io/udbhav1995@gmail.com")

# Shortcut
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
  File.read('_site/404.html')
end

get '/*' do
  file_name = "_site#{request.path_info}/index.html".gsub(%r{\/+},'/')
  if File.exists?(file_name)
    File.read(file_name)
  else
    raise Sinatra::NotFound
  end
end