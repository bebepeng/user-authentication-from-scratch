require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'User Authentication App' do

  before do
    DB[:users].delete
  end

  scenario 'User can Register' do
    visit '/'

    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Register'
    expect(page).to have_content 'Welcome, sample@example.com'

    click_on 'Logout'
    expect(page).to_not have_content "Welcome, sample@example.com"
    expect(page).to have_content "You are not logged in."
  end

  scenario 'User can login' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Register'
    click_on 'Logout'

    click_on 'Login'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Login'
    expect(page).to have_content 'Welcome, sample@example.com'
  end

  scenario 'User that has not registered cannot login' do
    visit '/'
    click_on 'Login'
    fill_in 'email', :with => "hey@hello.com"
    fill_in 'password', :with => "password"
    click_on 'Login'
    expect(page).to have_content 'Email / password is invalid'
  end

  scenario 'User should see error message if password is incorrectly entered' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Register'
    click_on 'Logout'

    click_on 'Login'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "oops"
    click_on 'Login'
    expect(page).to have_content 'Email / password is invalid'
  end
end