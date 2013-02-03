require 'spec_helper'


describe "Micropost pages" do
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "count of microposts" do
		before do
			FactoryGirl.create(:micropost, user: user) 
			visit root_path
		end
		describe "a single item" do
			it { should have_content("1 micropost") }
		end
		describe "multiple items" do
			before do
				FactoryGirl.create(:micropost, user: user) 
				visit root_path
			end
			it { should have_content("2 microposts") }
		end
	end
	
	describe "pagination" do
		before(:all) { 31.times { FactoryGirl.create(:micropost, user: user) } }
		after(:all) { user.feed.delete_all }
		
		before { visit root_path }

		it { should have_selector('div.pagination') }
		it "should list each micropost" do
			user.feed.paginate(page: 1).each do |m|
				page.should have_selector("li##{m.id}", text: m.content) 
			end
		end
	end
	
	describe "micropost creation" do
		before { visit root_path }
		
		describe "with invalid information" do
			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end
			describe "error messages" do
				before { click_button "Post" }
				it { should have_content("error") }
			end
		end
		
		describe "with valid information" do
			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end
	
	describe "destroy micropost" do
		before { FactoryGirl.create(:micropost, user: user) }
		
		describe "as correct user" do
			before { visit root_path }
			it "should delete a micropost" do
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end
	end
end
