kablammo
========

Kablammo!  the GoGaRuCo death match


Setup
-----

- Clone the repo
- Install dependancies: run `bundle`
- Start the server: run `rerun.sh`
- Run two or more strategy clients (see below)
- Create a new board `localhost:4567/battles/new`
- Link a strategy from github using your ssh repo url to a fork of kablammo-strategies `localhost:4567/strategies/new`
- TODO: specify which strategies to compete


Strategy Clients
----------------

- See http://github.com/carbonfive/kablammo-strategy


TODO:
-----

* make rerun ignore game_strategies directory (this is where we are going to pull repos) 
OR
* don't use rerun on the production server
