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