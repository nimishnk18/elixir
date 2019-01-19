defmodule AssigenservTest do
  use ExUnit.Case
  doctest Assigenserv

  setup do
    squaremap = start_supervised!(Assigenserv)
    %{squaremap: squaremap}
  end

  test "spawns buckets", %{squaremap: squaremap} do
    assert Assigenserv.lookup(squaremap, "squares") == :error

    Assigenserv.create(squaremap, "squares")
    assert {:ok, bucket} = Assigenserv.lookup(squaremap, "squares")

    Assignsquare.put(bucket, 2, 4)
    assert Assignsquare.get(bucket, 2) == 4
  end
end
