defmodule OembedServiceTest do
  use ExUnit.Case
  doctest OembedService

  test "greets the world" do
    assert OembedService.hello() == :world
  end
end
