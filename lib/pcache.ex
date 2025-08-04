defmodule Pcache do
  @moduledoc """
  `Pcache` a cache for an elixir process.
  """

  def reset(), do: :erlang.put(:pcache, %{})

  def size() do
    case(:erlang.get(:pcache)) do
      :undefined -> 0
      map -> map_size(map)
    end
  end

  def empty?(), do: size() == 0

  @doc """
  retrieve the value with `retrieve_fun.(key)` unless the value is already found with `key`.

  ## Example

      iex> Pcache.get!(123, fn k -> Process.sleep(1); k end)
      123

  """
  def get!(key, retrieve_fun) do
    case :erlang.get(:pcache) do
      %{^key => val} ->
        val

      :undefined ->
        val = retrieve_fun.(key)
        :erlang.put(:pcache, %{key => val})
        val

      tc ->
        val = retrieve_fun.(key)
        :erlang.put(:pcache, Map.put(tc, key, val))
        val
    end
  end

  @doc """
    same as get!/2 but returns also a boolean if the value is cached.

  ## Example

      iex> Pcache.get(123, fn k -> Process.sleep(1); k end)
      {123, false}
  """

  def get(key, retrieve_fun) do
    case :erlang.get(:pcache) do
      %{^key => val} ->
        {val, true}

      :undefined ->
        val = retrieve_fun.(key)
        :erlang.put(:pcache, %{key => val})
        {val, false}

      tc ->
        val = retrieve_fun.(key)
        :erlang.put(:pcache, Map.put(tc, key, val))
        {val, false}
    end
  end
end
