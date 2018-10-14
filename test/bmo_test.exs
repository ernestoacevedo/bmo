defmodule BmoTest do
  use ExUnit.Case
  doctest Bmo

  test "greets the world" do
    assert Bmo.hello() == :world
  end
end
