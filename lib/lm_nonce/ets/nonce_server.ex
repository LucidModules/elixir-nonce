defmodule LmNonce.Ets.NonceServer do
  @moduledoc """
  This is a GenServer for the Nonce management.
  TODO: configurable ets_name
  """

  use GenServer

  alias LmNonce.Api.Nonce

  @ets_name :lm_nonce

  @doc """
  Start our queue and link it.
  This is a helper function
  """
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback
  """
  def init(state) do
    :ets.new(@ets_name, [:set, :protected, :named_table])

    {:ok, state}
  end

  @doc """
  GenServer.handle_call/3 callback
  """
  def handle_call({:insert, %{value: value} = nonce}, _from, state) do
    case :ets.insert_new(@ets_name, {value, nonce}) do
      true -> {:reply, nonce, state}
      _ -> {:reply, nil, state}
    end
  end

  def handle_call({:get_and_dispose, nonce}, _from, state) when is_binary(nonce) do
    case :ets.take(@ets_name, nonce) do
      [result | _] -> {:reply, result, state}
      _ -> {:reply, nil, state}
    end
  end

  @doc """
  Insert a new nonce
  """
  @spec insert(Nonce.t()) :: {:ok, Nonce.t()} | {:error, binary()}
  def insert(nonce), do: GenServer.call(__MODULE__, {:insert, nonce})

  @doc """
  Retrieve nonce and remove it (if exists)
  """
  @spec get_and_dispose(Nonce.nonce_value()) :: Nonce.t() | nil
  def get_and_dispose(nonce_value) when is_binary(nonce_value),
    do: GenServer.call(__MODULE__, {:get_and_dispose, nonce_value})
end
