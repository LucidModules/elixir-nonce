defmodule LmNonce.Api.Nonce do
  @moduledoc """
  API for the Nonce generation and storage.

  According to the RFC7616 a nonce should be an uniquely generated string, ideally base 64 encoded with url safe alphabet.
  """

  @type nonce_value :: binary()
  @type error :: binary()

  @type t :: %{value: nonce_value(), expires_at: DateTime.t()}

  @doc """
  Creates a new nonce and returns it.

  Nonce should be short-lived.
  """
  @callback create(t()) :: {:ok, t()} | {:error, error()}

  @doc """
  Retrieves nonce and disposes it immediately. Prevents consecutive access to the same nonce.

  When two processes try to retrieve the nonce, only the first one must claim the nonce.
  A meaningful error should be returned for other processes describing a cause of failure.

  Underlying implementation is responsible for the access locking. Transaction mechanism is a good fit here.

  Nonce expires after some timer. This function should return appropriate error when if nonce has been expired.
  Nonce expiration mechanism can be implemented in lazy mode.
  Thus, expire time can be verified on the function call.
  """
  @callback get_and_dispose(nonce_value()) :: {:ok, t()} | {:error, error()}
end
