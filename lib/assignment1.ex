defmodule Assignment1 do


  def get_square_root(low, high, counter, mod) do
    actual_counter =
      if low <= mod do
        counter + 1
      else
        counter
      end
    {_, square_genserver} = Assigenserv.start_link([])
    Assigenserv.create(square_genserver, "squares")
    {:ok, bucket} = Assigenserv.lookup(square_genserver, "squares")
    return = Assigenserv.get_square_root(square_genserver, bucket, low, high, actual_counter)
    Process.exit(bucket,:kill)
    Assigenserv.stop(square_genserver, :normal)
    return
  end

  def create_squaring_processes(n, k) when n < 100000 do
    square_roots = 1..n |> Enum.map(fn n -> Task.async(fn -> get_square_root(n, n+k-1, 1, 0) end) end) |> Enum.map(fn n -> Task.await(n) end)
    _final = Enum.reduce(square_roots, [], fn n, acc ->
      if n != nil do
        acc ++ n
      else
        acc
      end
    end)
  end

  def create_squaring_processes(n, k) do
    counter = div(n, 100000)
    mod = rem(n, 100000)
    square_roots = 1..100000 |> Enum.map(fn n -> Task.async(fn -> get_square_root(n, n+k-1, counter, mod) end) end) |> Enum.map(fn n -> Task.await(n) end)
    _final = Enum.reduce(square_roots, [], fn n, acc ->
      if n != nil do
        acc ++ n
      else
        acc
      end
    end)
  end


  def start() do
    [n, k] = System.argv()
    {n, _} = Integer.parse(n)
    {k, _} = Integer.parse(k)
    IO.inspect create_squaring_processes(n, k)
  end
end

Assignment1.start()

