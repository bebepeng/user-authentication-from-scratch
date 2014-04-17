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
    fill_in 'confirmation_password', :with => "password"
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
    fill_in 'confirmation_password', :with => "password"
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
    fill_in 'confirmation_password', :with => "password"
    click_on 'Register'
    click_on 'Logout'

    click_on 'Login'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "oops"
    click_on 'Login'
    expect(page).to have_content 'Email / password is invalid'
  end

  scenario 'Admin can see a list of all users' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    fill_in 'confirmation_password', :with => "password"
    click_on 'Register'

    DB[:users].where(:email => 'sample@example.com').update(:admin => true)

    click_on 'Logout'
    click_on 'Login'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    click_on 'Login'
    click_on 'View all users'
    expect(page).to have_content 'Users'
  end

  scenario 'Non-admin cannot access list of all users' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    fill_in 'confirmation_password', :with => "password"
    click_on 'Register'
    expect(page).to_not have_content 'View all users'

    visit '/users'
    expect(page).to have_content 'Not Found'
  end

  scenario 'User cannot register if password does not match confirmation password' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "password"
    fill_in 'confirmation_password', :with => "oops"
    click_on 'Register'
    expect(page).to have_content 'Passwords do not match'
  end

  scenario 'User cannot register if password is less then 3 characters' do
    visit '/'
    click_on 'Register'
    fill_in 'email', :with => "sample@example.com"
    fill_in 'password', :with => "123"
    fill_in 'confirmation_password', :with => "123"
    click_on 'Register'
    expect(page).to have_content 'Password is too short (3 character min)'
  end
end