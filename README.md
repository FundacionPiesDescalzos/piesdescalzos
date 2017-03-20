## How to run with docker 🐳

Clone the project

    git clone git@github.com:fundacionpiesdescalzos/piesdescalzos
    
Build the docker containers

    cd piesdescalzos
    docker-compose build
    
Install gems

    docker-compose run app bundle install

Setup database

    docker-compose run app bundle exec rake db:setup

Run

    docker-compose up
    
Then go to 
 * [http://localhost:3000/](http://localhost:3000/) (login: ```user@example.com```, password: ```changeme```)
