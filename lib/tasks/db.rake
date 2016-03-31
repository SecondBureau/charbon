namespace :db do
  desc "Seed Authors"
  task seed_authors: :environment do
    filename = "authors.csv"
    
    firstname = Faker::Name.first_name
    lastname  = Faker::Name.last_name
    twitter = "#{firstname.downcase}_#{lastname.downcase}"
    role = 'client'
    email   = "#{firstname.downcase}.#{lastname.downcase}@local.net"
    password = 'secret'

    u = CamaleonCms::User.create(username: "#{firstname.downcase}#{lastname.downcase}", role: role, email: email, password: password, password_confirmation:password)

    u.set_meta_from_form({first_name: firstname, last_name: lastname})

    avatar = avatars[idx]
    u.set_meta 'avatar', avatar
    
  end

  desc "TODO"
  task seed_posts: :environment do
  end

end
