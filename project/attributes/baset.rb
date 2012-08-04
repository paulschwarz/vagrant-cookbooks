default[:app][:staging][:server_name]        = "bt.mss.co.ke"
default[:app][:staging][:server_aliases]     = ["*.bt.mss.co.ke"]
default[:app][:staging][:docbase]            = "/home/baset/staging"
default[:app][:staging][:docroot]            = "/home/baset/staging/current/public"
default[:app][:staging][:server_env]         = "staging"

default[:app][:production][:server_name]     = "basetitanium.com"
default[:app][:production][:server_aliases]  = ["*.basetitanium.com"]
default[:app][:production][:docbase]         = "/home/baset/production"
default[:app][:production][:docroot]         = "/home/baset/production/current/public"
default[:app][:production][:server_env]      = "production"