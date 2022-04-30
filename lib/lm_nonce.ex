defmodule LmNonce do
  @moduledoc """
  TODO: write about LmNonce usage and configuration
  This is the entry point of LmNonce library.
  TODO: rename to NonceBehaviour (or NonceStoreBehaviour) and NonceFactoryBehaviour
  TODO: for NonceEts a server must be started by the user. Alternatively, provide init callback
  """

  alias LmNonce.Api.Nonce
  alias LmNonce.Api.NonceFactory

  @default_nonce_length 42

  @spec create() :: {:ok, Nonce.t()} | {:error, Nonce.error()}
  def create do
    @default_nonce_length
    |> factory_impl().create()
    |> create_nonce()
    |> nonce_impl().create()
  end

  @spec verify(Nonce.nonce_value()) :: boolean()
  def verify(nonce_value) do
    nonce_impl().get_and_dispose(nonce_value)
    |> verify_not_expired
  end

  defp verify_not_expired({:ok, %{expires: expires}}) do
    now = DateTime.now!("Etc/UTC")

    case DateTime.compare(now, expires) do
      :gt -> false
      _ -> true
    end
  end

  defp verify_not_expired(_), do: false

  defp create_nonce(nonce_value) when is_binary(nonce_value) do
    %{
      value: nonce_value,
      expires: get_expires(15 * 60)
    }
  end

  defp get_expires(seconds) when is_number(seconds) do
    DateTime.now!("Etc/UTC")
    |> DateTime.add(15 * 60, :second)
  end

  defp nonce_impl() do
    Application.get_env(:lm_nonce, :nonce, LmNonce.Ets.NonceEts)
  end

  defp factory_impl() do
    Application.get_env(:lm_nonce, :nonce_factory, LmNonce.Factory.Base64NonceFactory)
  end
end
