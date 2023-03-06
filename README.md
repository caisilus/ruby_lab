# RubyLab
RubyLab is a web application for teaching Ruby and Ruby on Rails. It automatically tests student's code and display percentage of tests passed. 

# Features
This project is in development. Not all of the features below are implemented.

## Github integration
You can log-in via github and add a link to a repo: RubyLab will trace your commits and test your committed code automatically.

## Real-time updates
There is no need to refresh the page after you push your code. Your score will be updated in real time.

## Gamification
Scoring system is aimed to create motivation and determine your strengths and weaknesses.

# Development
To be able to contribute to the app, follow this steps:

1) Clone this repo
2) Install required **ruby version** (3.2.1)
3) Install gem bundler
4) Install **redis**: https://redis.io/docs/getting-started/installation/
5) Install node js and yarn
6) Run


    bundle install
7) Run

    
    yarn install
8) Install postgresql
9) Create .env file and enter your db cridentials like that:


    DATABASE_USERNAME=USERNAME
    DATABASE_PASSWORD=PASSWORD


10) Create and migrate database. Run


    bundle exec rake db:create
    bundle exec rake db:migrate
11) To have example data, run


    bundle exec rake db:seed