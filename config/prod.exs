use Mix.Config

config :at_ex,
  api_key: "1eab43cb7d67fc7cccf2f393ad337b687b44adc96cd9292245363481583e2502",
  content_type: "application/x-www-form-urlencoded",
  accept: "application/json",
  auth_token: "",
  username: "sandbox",
  endpoint: "sandbox",
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "boiling-fortress-43824.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
