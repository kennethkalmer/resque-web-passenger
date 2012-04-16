require 'rubygems'
require 'bundler/setup'

require 'resque/server'
require 'resque_scheduler'
require 'resque/status_server'
require 'json'

require 'yaml'

# Our config
config = YAML.load_file( File.expand_path('../resque-web.yml', __FILE__) )

# Load resque config
redis_config = YAML.load_file( config['resque']['config_path'] )
redis_config = redis_config[ config['resque']['environment'] ] if config['resque']['environment']

# Setup resque
Resque.redis = redis_config
Resque.redis.namespace = config['resque']['namespace'] if config['resque']['namespace']

if config['scheduler']
  # Load scheduler config
  schedule_config = YAML.load_file( config['scheduler']['config_path'] )
  schedule_config = redis_config[ config['scheduler']['env_key'] ] if config['scheduler']['env_key']

  # Setup the scheduler
  Resque.schedule = schedule_config
end

# If a password is provided, setup basic auth
if config['password']
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == config['password']
  end
end

use Rack::ShowExceptions

run Rack::URLMap.new \
  "/resque" => Resque::Server.new

