json.user do 
  json.id @user.id
  json.username @user.username
  json.role @user.role
  json.email @user.email
  json.avatar @user.get_meta('avatar')
  json.twitter @user.get_meta("twitter")
  json.slogan @user.get_meta("slogan")
  json.fullname @user.fullname
end