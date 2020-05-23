defmodule AtSampleAppTest do
  use ExUnit.Case
  doctest AtSampleApp

  test "greets the world" do
    assert AtSampleApp.hello() == :world
  end
end
