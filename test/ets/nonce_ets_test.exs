defmodule LmNonceTest.Ets.NonceEtsTest do
  use ExUnit.Case, async: false

  alias LmNonce.Ets.NonceEts
  alias LmNonce.Ets.NonceServer

  describe "given NonceEts::create/1" do
    setup do
      start_supervised!(NonceServer)

      :ok
    end

    test "it creates and returns nonce" do
      nonce = %{value: "test_nonce", expires: DateTime.now!("Etc/UTC")}

      assert {:ok, ^nonce} = NonceEts.create(nonce)
    end

    test "it rejects creating an existing nonce" do
      existing_nonce = %{value: "existing_nonce", expires: DateTime.now!("Etc/UTC")}
      NonceEts.create(existing_nonce)

      assert {:error, "Nonce already exists"} = NonceEts.create(existing_nonce)
    end
  end

  describe "given NonceEts::get_and_dispose/1" do
    setup do
      start_supervised!(NonceServer)

      nonce_value = "existing_nonce"
      existing_nonce = %{value: nonce_value, expires: DateTime.now!("Etc/UTC")}
      {:ok, _} = NonceEts.create(existing_nonce)

      [nonce_value: nonce_value]
    end

    test "it retrieves and disposes nonce", %{nonce_value: nonce_value} do
      assert {:ok, %{value: ^nonce_value}} = NonceEts.get_and_dispose(nonce_value)
    end

    test "it returns error for nonce accessed more than once", %{nonce_value: nonce_value} do
      assert {:ok, _} = NonceEts.get_and_dispose(nonce_value)
      assert {:error, "Invalid nonce"} = NonceEts.get_and_dispose(nonce_value <> "_fake")
    end

    test "it returns error for not existing nonce", %{nonce_value: nonce_value} do
      assert {:error, "Invalid nonce"} = NonceEts.get_and_dispose(nonce_value <> "_fake")
    end
  end
end
