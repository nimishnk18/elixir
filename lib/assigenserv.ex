defmodule Assigenserv do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name}, 30000)
  end

  def get_square_root(server, name, low, high, counter) do
    if counter <= 1 do 
      GenServer.cast(server, {:create_squares, name, low, high}) 
      return = GenServer.call(server, {:get_square_root, name}, 300000)
      if Float.ceil(return) == return do
        [low]
      else
        []
      end
    else
      GenServer.cast(server, {:create_squares, name, low, high})
      return = GenServer.call(server, {:get_square_root, name}, 300000)
      returned = get_square_root(server, name, low+100000, high+100000, counter-1)
      if Float.ceil(return) == return do
       [low] ++ returned
      else
        returned
      end
    end
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  def stop(server, reason) do
    GenServer.stop(server, reason)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:get_square_root, name}, _from, names) do
    return = Assignsquare.get_square_root(name)
    {:reply, return, names}
  end

  def handle_cast({:create_squares, name, low, high}, names) do
    Assignsquare.put(name, low, high)
    {:noreply, names}
  end

  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = Assignsquare.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end
end
