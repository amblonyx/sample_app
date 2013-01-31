namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		# Create an admin user
		admin = User.create!(	name: "Example User",
						email: "example@railstutorial.org",
						password: "foobar",
						password_confirmation: "foobar")
		admin.toggle!(:admin)
		
		# Create 99 other users (non-admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(	name: name,
							email: email,
							password: password,
							password_confirmation: password)
		end
		
		# Create 50 microposts for the first 6 users
		users = User.all(limit: 6)
		50.times do |n|
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end