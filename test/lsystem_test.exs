defmodule LSystemTest do
  use ExUnit.Case



  test "the truth" do
    # model = LSystem.Model.new('0', %{?1 => '11', ?0 => '1[0]0'})
    # drawer = PythagorasDrawer.new({0, 0}, :math.pi/2)

    # model =
    #   1..3
    #   |> Enum.reduce(model, fn(_, model) -> LSystem.Model.next(model) end)

    # drawer
    # |> PythagorasDrawer.draw(LSystem.Model.state(model))

    # :timer.sleep(:infinity)

    PythagorasDrawer.generate(15, 1/300)
    :timer.sleep(:infinity)
  end
end
