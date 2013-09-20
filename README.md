kablammo
========

Kablammo!  the GoGaRuCo death match


Dependencies
------------
* Ruby 1.9.3
* MongoDB 2.2+
* Redis

Setup
-----

- Clone the repo
- Install dependancies: run `bundle`
- Start the server: run `ruby index.rb`
- Run two or more strategy clients (see below)
- Add your bot `http://localhost:4567/strategies/new`
  - NOTE: Instead of putting in a github url, you can just put the path
to your repo locally
- Add another bot (since you need two to fight!)
- Go to the arena! `http://localhost:4567/battles/new`


Strategy Clients
----------------

- See http://github.com/carbonfive/kablammo-strategy
