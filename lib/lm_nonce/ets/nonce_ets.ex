defmodule LmNonce.Ets.NonceEts do
  @moduledoc """
  ETS implementation for the Nonce
  """

  @behaviour LmNonce.Api.Nonce

  alias LmNonce.Ets.NonceServer

  @doc """
  Create new nonce
  """
  @spec create(Nonce.t()) :: {:ok, Nonce.t()} | {:error, binary()}
  @impl true
  def create(nonce) do
    case NonceServer.insert(nonce) do
      nil -> {:error, "Nonce already exists"}
      nonce -> {:ok, nonce}
    end
  end

  @doc """
  Retrieves nonce and disposes it immediately. Prevents consecutive access to the same nonce.
  """
  @spec get_and_dispose(Nonce.nonce_value()) :: {:ok, Nonce.t()} | {:error, binary()}
  @impl true
  def get_and_dispose(nonce_value) when is_binary(nonce_value) do
    case NonceServer.get_and_dispose(nonce_value) do
      nil -> {:error, "Invalid nonce"}
      {_key, nonce} -> {:ok, nonce}
    end
  end
end
