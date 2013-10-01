kablammo
========

Kablammo!  the robot death match


Dependencies
------------
* Ruby 1.9.3
* MongoDB 2.2+
* Redis

Setup
-----

### Verify your dependencies
You must have ruby 1.9.3 installed.  Out of the box Kablammo assumes 1.9.3-p429, but you can alter the .ruby-version file to another patch version.

You also must have Mongo and Redis installed and running, using the default settings.

### Clone the repo
```
git clone https://github.com/carbonfive/kablammo.git
cd kablammo
```

### Install dependencies
```
gem install bundler
bundle
```

### Start the server
```
rackup
```

### Build your bot
Check out the instructions at `http://github.com/carbonfive/kablammo-strategy`

### Install your bot locally
`http://localhost:9292/strategies/new`

- HINT: Instead of putting in a github url, you can just put the path to your repo on your file system

You should probably actually add your bot twice (with two different names), so that you have someone to fight against!

### Go to the arena
`http://localhost:9292/battles/new`
