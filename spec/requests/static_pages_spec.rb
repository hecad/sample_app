require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do |option|
    it { should have_selector('h1',    text: option[:heading]) }
    it { should have_selector('title', text: full_title(option[:page_title])) }
  end

  describe "Home page" do
    before { visit root_path }
    describe "for unsigned-in users" do
      it_should_behave_like "all static pages", {heading: 'Sample App', page_title: ''}
      it { should_not have_selector 'title', text: '| Home' }
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "how the counter of microposts is redered" do
        subject { page }
        let(:another_user) { FactoryGirl.create(:user) }
        before do
          sign_in another_user
          visit root_path
        end

        describe "when 0 microposts" do
          it { should have_selector("span", text: "0 microposts") }    
        end

        describe "when 1 micropost" do
          before do
           FactoryGirl.create(:micropost, user: another_user, content: "Lorem ipsum") 
           visit root_path
          end
          it { should have_selector("span", text: "1 micropost") }    
        end
        
        describe "when 2 micropost" do
          before do
           FactoryGirl.create(:micropost, user: another_user, content: "Lorem ipsum") 
           FactoryGirl.create(:micropost, user: another_user, content: "Lorem ipsum")
           visit root_path
         end
          it { should have_selector("span", text: "2 microposts") }    
        end
      end
    end
  end
  
  describe "Help page" do
    before { visit help_path }
    it_should_behave_like "all static pages", {heading: 'Help', page_title: 'Help'}
  end

  describe "About page" do
    before { visit about_path }
    it_should_behave_like "all static pages", {heading: 'About Us', page_title: 'About Us'}
  end

  describe "Contact page" do
    before { visit contact_path }
    it_should_behave_like "all static pages", {heading: 'Contact', page_title: 'Contact'}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end
end
