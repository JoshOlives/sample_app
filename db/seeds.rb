User.create!(name:  "Joshua Olivares",
             email: "joshuaolivares@utexas.edu",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
             
99.times do |n|
    name = Faker::Name.name #??? whats the double : mean?
    email = "example-#{n}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
             email: email,
             password:              password,
             password_confirmation: password,
             activated: true,
             activated_at: Time.zone.now)
end

#Microposts
#default is :asc, old to new
#reorder or unscoped overrides default_scope
users = User.unscoped.order(:created_at).take(6)
50.times do
    #why arent all the sentences 5 words long?
    content = Faker::Hipster.sentence(5,false,5)
    #good review of other way to make block
    users.each { |user| user.microposts.create!(content: content) }
end

#Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }