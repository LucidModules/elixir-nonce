defmodule LmNonce.Factory.Base64NonceFactory do
  @moduledoc """
  Url safe Base64 nonce generator.
  """

  @behaviour LmNonce.Api.NonceFactory

  @default_nonce_length 42

  @doc """
  Creates Base64, url-safe nonce string.
  """
  @impl true
  @spec create(integer()) :: binary()
  def create(length \\ @default_nonce_length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> binary_part(0, length)
  end
end
