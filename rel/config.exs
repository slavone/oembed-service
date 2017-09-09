use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :prod

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"BvMh=ZEOwPZpzO9[{*.*}]HyPQbqb/VshHx>L9.]z3918qa3lknFX<{]dv*qP_6O"
end

environment :prod do
  set include_erts: false
  set include_src: false
  set cookie: :"BvMh=ZEOwPZpzO9*}]HyPQbqb/VshHx>L9.]z3918qa3lknFX<{ewo!]dv*qP_6O"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :oembed_service do
  set version: current_version(:oembed_service)
end
