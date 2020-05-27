use Mix.Config

config :elastic,
  index_prefix: "elastic",
  use_mix_env: true,
  base_url: "http://localhost:9200",
  clusters: %{
    c1: "http://localhost:9201"
  }
