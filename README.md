# LmNonce

Elixir nonce generator and storage.
- custom nonce factory
- specific nonce storage
  - ETS
  - Mnesia - for distributed systems
  - custom
- nonce disposal (lazy)
  - on nonce retrieval, check it's expiration date
- options for strenghtening the nonce
  - verify nonce was used already
  - bind nonce to the user session

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lm_nonce` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lm_nonce, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/lm_nonce>.

