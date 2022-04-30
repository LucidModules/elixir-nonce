defmodule LmNonce.Factory.Base64NonceFactoryTest do
  use ExUnit.Case, async: true
  doctest LmNonce.Factory.Base64NonceFactory

  alias LmNonce.Factory.Base64NonceFactory

  describe "given LmNonce.Factory.Base64NonceFactory::create/1" do
    test "it returns string with requested length" do
      assert 42 = String.length(Base64NonceFactory.create(42))
      assert 1 = String.length(Base64NonceFactory.create(1))
    end

    test "it returns default 42 length string with no specified parameter" do
      assert 42 = String.length(Base64NonceFactory.create(42))
    end

    test "it contains only allowed characters" do
      result = Base64NonceFactory.create(128)
      assert String.match?(result, ~r/[A-Za-z_-]/)
      refute String.match?(result, ~r/[=\+]/)
    end
  end
end
