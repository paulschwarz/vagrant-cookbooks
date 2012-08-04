default[:app][:staging][:server_name]        = "bt.mss.co.ke"
default[:app][:staging][:server_aliases]     = ["*.bt.mss.co.ke"]
default[:app][:staging][:docroot]            = "/home/baset/staging/public"
default[:app][:staging][:server_env]         = "staging"
default[:app][:staging][:extra_packages]     = []

default[:app][:production][:server_name]        = "basetitanium.com"
default[:app][:production][:server_aliases]     = ["*.basetitanium.com"]
default[:app][:production][:docroot]            = "/home/baset/production/public"
default[:app][:production][:server_env]         = "production"
default[:app][:production][:extra_packages]     = []