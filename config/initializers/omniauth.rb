Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '804130923273.apps.googleusercontent.com', '87t6cJnvNqE-FZwgZrZCrYd-',
             {
             :scope => "userinfo.email,userinfo.profile",
             :approval_prompt => "auto"
           }
end

