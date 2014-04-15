require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'User Authentication App' do
  scenario 'User can Register' do
    visit '/'

    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Register'
    expect(page).to have_content 'Welcome, sample@example.com'

    click_on 'Logout'
    expect(page).to_not have_content "Welcome, sample@example.com"
  end
end