# Playframework::Capistrano

PlayFramework / Capistrano Integration Gem.

## Important

Use the branch `master` if you are developing with PlayFramework >= 2.2.0.

If you are stuck in previous versions of PlayFramework, go to `playframework-2.1.x-compatible` branch.

## Installation

PlayFramework / Capistrano integration is available as a separate gem. Add this line to your application's [Gemfile](https://github.com/tomasmuller/playframework-neo4j-template/blob/master/Gemfile):

    gem 'playframework-capistrano'

or

    gem 'playframework-capistrano', '0.0.5' # for PlayFramework < 2.2.0

And then execute:

    $ bundle

## Usage

Configure your project ([sample project](https://github.com/tomasmuller/playframework-neo4j-template)):
- [Capfile](https://github.com/tomasmuller/playframework-neo4j-template/blob/master/Capfile)
- [conf/deploy.rb](https://github.com/tomasmuller/playframework-neo4j-template/blob/master/conf/deploy.rb)

Run `cap -vT` to see all the available tasks.

#### Deploying your PlayFramework app using PlayFramework/Capistrano Integration Gem:

`cap deploy:setup` (Prepares one or more servers for deployment.)

`cap deploy:check` (Test deployment dependencies.)

`cap deploy` (Deploys your project.)

`cap playframework:start_dev` || `cap playframework:start_prod` (Start your application.)

`cap playframework:stop`  (Stop your application.)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
