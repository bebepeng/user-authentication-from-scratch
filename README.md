## Development
1. Copy the `.env.example` file to `.env`.
1. Change the `.env` file to include your database connection strings for both your development
and test databases. This file is ignored by git (see .gitignore) to protect your secrets
from the outside world.
1. `bundle install`
1. Create a database by running `psql -d postgres -f scripts/create_databases.sql`
1. Run the migrations in the development database using `rake db:migrate`. If you would
like to migrate to a specific version you can do so using this rake task. Run `rake -T` for
details.
1. `rerun rackup`
    * running rerun will reload app when file changes are detected
1. Run tests using `rspec`. The tests will clean up the database before each test run.

## Migrations on Heroku
To run the migrations on heroku, run `heroku run 'rake db:migrate' --app <App name>`. If you
do not have a Heroku configuration variable named DATABASE_URL, then you will need to create one.

#URLs
Staging URL: cryptic-falls-6403.herokuapp.com
Production URL: salty-eyrie-1228.herokuapp.com
Tracker URL: https://www.pivotaltracker.com/n/projects/1060100