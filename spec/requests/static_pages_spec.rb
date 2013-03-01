require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do |option|
    it { should have_selector('h1',    text: option[:heading]) }
    it { should have_selector('title', text: full_title(option[:page_title])) }
  end

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like "all static pages", {heading: 'Sample App', page_title: ''}
    it { should_not have_selector 'title', text: '| Home' }
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
end
