FactoryGirl.define do
	factory :user do
		name		"Tiny Wee Sheep"
		email		"tws@example.com"
		password	"foobar"
		password_confirmation "foobar"
	end
end