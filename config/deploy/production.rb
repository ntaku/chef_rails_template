
role :app, %w{vagrant@192.168.50.12}
role :web, %w{vagrant@192.168.50.12}
role :db,  %w{vagrant@192.168.50.12}

server '192.168.50.12', user: 'vagrant', roles: %w{app web db}

set :ssh_options, {
  user: 'vagrant',
  keys: ["/Users/ntaku/.vagrant.d/insecure_private_key"],
  auth_methods: ["publickey"]
#  forward_agent: true
}
