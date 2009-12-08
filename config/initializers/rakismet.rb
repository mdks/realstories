Rakismet::KEY  = '4f1d23abaf3a'
if RAILS_ENV == 'development'
  Rakismet::URL  = 'http://72.174.126.254:3000'
else
  Rakismet::URL  = 'http://realstories.heroku.com'
end
Rakismet::HOST = 'rest.akismet.com'