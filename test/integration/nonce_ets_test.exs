defmodule LmNonceTest.Integration.NonceEtsTest do
  use ExUnit.Case, async: false

  alias LmNonce.Factory.Base64NonceFactory
  alias LmNonce.Ets.NonceEts
  alias LmNonce.Ets.NonceServer

  describe "given NonceEts configured for LmNonce" do
    setup do
      start_supervised!(NonceServer)
      Application.put_env(:lm_nonce, :nonce, NonceEts)
      Application.put_env(:lm_nonce, :nonce_factory, Base64NonceFactory)

      :ok
    end

    test "it creates and returns nonce with value generated in the factory" do
      assert {:ok, %{value: value, expires: expires}} = LmNonce.create()
      assert String.length(value) === 42

      future_15_mins = DateTime.now!("Etc/UTC") |> DateTime.add(15 * 60, :second)
      refute :gt === DateTime.compare(expires, future_15_mins)
    end
  end

  describe "given NonceEts configured for LmNonce and nonce has been created" do
    setup do
      start_supervised!(NonceServer)
      Application.put_env(:lm_nonce, :nonce, NonceEts)
      Application.put_env(:lm_nonce, :nonce_factory, Base64NonceFactory)

      {:ok, %{value: value}} = LmNonce.create()

      [nonce_value: value]
    end

    test "it retrieves and disposes nonce", %{nonce_value: nonce_value} do
      assert true === LmNonce.verify(nonce_value)
      assert false === LmNonce.verify(nonce_value)
    end

    test "it returns false for not existing nonce", %{nonce_value: nonce_value} do
      assert false === LmNonce.verify(nonce_value <> "_fake")
    end
  end
end
