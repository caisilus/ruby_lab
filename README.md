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
5) Install **ngrok**: https://ngrok.com/download
6) Install node js and yarn
7) Run


    bundle install
8) Run

    
    yarn install
9) Install postgresql
10) Create .env file and enter your db cridentials like that:


    DATABASE_USERNAME=USERNAME
    DATABASE_PASSWORD=PASSWORD
11) Create and migrate database. Run


    bundle exec rake db:create
    bundle exec rake db:migrate
12) To have example data, run


    bundle exec rake db:seed

## Before starting server

1) Run foreman start to have life-reload for js and css


    foreman start -f Procefile.dev

2) Start redis service.


    sudo service redis-server start

On Windows it will work via WSL.

3) Start ngrok server


    ngrok http 3000
4) Set **DEV_URL** env variable to the url **ngrok** provides.
5) Run server


    rails s

### Latest feature:

Instead of making steps 3-5, you can now create ngrok.yml configuration file in `lib/tasks` like this:
    
    version: "2"
    console_ui: false
    authtoken: <your auth token>

When you have this file, you can run **both ngrok and server** using rake task:
    
    rails ngrok:start