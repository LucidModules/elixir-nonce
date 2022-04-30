defmodule LmNonce.Api.NonceFactory do
  @moduledoc """
  Nonce value generator.
  """

  alias LmNonce.Api.Nonce

  @type length :: integer()

  @doc """
  Creates a new nonce payload of specific length.
  """
  @callback create(length()) :: Nonce.nonce_value()
end
