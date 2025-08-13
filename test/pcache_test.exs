defmodule PcacheTest do
  use ExUnit.Case
  doctest Pcache

  test "get/1 return tuple" do
    val = Pcache.get(12, &is_atom/1)

    assert is_tuple(val)
  end

  test "empty => empty?" do
    assert Pcache.empty?() == true
  end

  test "non empty => empty?" do
    Pcache.get(12, &is_atom/1)
    refute Pcache.empty?() == true
  end

  test "1 x get/1 cached? false" do
    {val, cached?} = Pcache.get(12, &is_atom/1)
    assert val == false
    refute cached?
  end

  test "2 x get/1 cached? true" do
    _ = Pcache.get(12, &is_atom/1)
    {val, cached?} = Pcache.get(12, &is_atom/1)
    assert val == false
    assert cached?
  end

  test "content/0" do
    assert is_nil(Pcache.content())
    _ = Pcache.get(:a, &is_atom/1)
    _ = Pcache.get(:b, &is_atom/1)
    assert %{a: true, b: true}
  end

  @iters 500
  @val :math.pi() / 4

  test "perf no cache" do
    {time, _} = :timer.tc(fn -> Enum.each(1..@iters, fn _ -> heavy_computation(@val) end) end)
    IO.write("\nno cache throughput: #{div(@iters * 1_000_000, time)} ops/s.")
  end

  test "perf with cache" do
    {time, _} =
      :timer.tc(fn ->
        Enum.each(1..@iters, fn _ -> Pcache.get(@val, &heavy_computation/1) end)
      end)

    IO.write("\ncache throughput: #{div(@iters * 1_000_000, time)} ops/s.")
  end

  defp heavy_computation(k) do
    Process.sleep(1)
    k
  end
end
