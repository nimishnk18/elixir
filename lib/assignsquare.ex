defmodule Assignsquare do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start(fn -> %{} end)
  end

  @doc """
  Get a value from the 'bucket' by 'key'.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Put the 'value' for the given 'key' in the 'bucket'.
  """
  def put(bucket, low, high) do
    squares = Enum.map(low..high, fn n -> n*n  end)
    Agent.update(bucket, fn state -> %{} end)
    Agent.update(bucket, &Map.put(&1, "squares", squares))
  end

  def get_square_root(bucket) do
    {_, square} = Enum.map_reduce(Agent.get(bucket, &Map.get(&1, "squares")), 0, fn n, acc -> {n, n + acc} end)
    :math.sqrt(square)
  end
end
