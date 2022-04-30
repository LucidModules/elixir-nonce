defmodule LmNonceTest do
  use ExUnit.Case, async: false
  doctest LmNonce

  import Mox

  setup :verify_on_exit!

  describe "given LmNonce::create/1" do
    setup do
      expect(NonceFactoryMock, :create, fn _length -> "random_nonce" end)

      expect(NonceMock, :create, fn args ->
        assert %{value: "random_nonce", expires: _expired} = args

        {:ok, args}
      end)

      :ok
    end

    test "it creates and returns nonce with value generated in the factory" do
      assert {:ok, %{value: "random_nonce", expires: _expires}} = LmNonce.create()
    end

    test "it creates and returns nonce with expires time set to 15 minutes" do
      now = DateTime.now!("Etc/UTC")

      assert {:ok, %{value: _, expires: expires}} = LmNonce.create()
      assert 15 * 60 <= DateTime.diff(expires, now)
    end
  end

  describe "given LmNonce::verify/2" do
    setup do
      expect(NonceMock, :get_and_dispose, &get_and_dispose_mock/1)

      :ok
    end

    test "it returns true with existing nonce" do
      assert true === LmNonce.verify("existing_nonce")
    end

    test "it returns false with not existing nonce" do
      assert false === LmNonce.verify("not_existing_nonce")
    end

    test "it returns false with expired nonce" do
      assert false === LmNonce.verify("expired_nonce")
    end
  end

  defp get_and_dispose_mock("not_existing_nonce") do
    {:error, "Nonce not found"}
  end

  defp get_and_dispose_mock("existing_nonce") do
    expires = DateTime.now!("Etc/UTC") |> DateTime.add(15 * 60, :second)
    {:ok, %{value: "existing_nonce", expires: expires}}
  end

  defp get_and_dispose_mock("expired_nonce") do
    expires = DateTime.now!("Etc/UTC") |> DateTime.add(-1, :second)
    {:ok, %{value: "expired_nonce", expires: expires}}
  end
end
