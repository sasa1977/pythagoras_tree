defmodule PythagorasTree do
  @branch_length 3
  @leaf_length 1

  def generate(level, opts \\ []) do
    opts = Keyword.merge([pos: {20, 20}, size: 1000], opts)

    downscale = :math.pow(2, level-1) * @branch_length / opts[:size]
    title = "Pythagoras Tree, level=#{level}, downscale=#{downscale}"

    opts
    |> Keyword.merge(downscale: downscale, title: title, level: level)
    |> init_state
    |> generate_recursive
  end

  defp init_state(opts) do
    {:ok, painter} = Painter.start_link(opts)
    %{
      line_segment: LineSegment.new(opts[:downscale]),
      painter: painter,
      size: opts[:size],
      level: opts[:level],
      current_level: 1
    }
  end

  defp inc_level(state), do: %{state | current_level: state.current_level + 1}
  defp remaining_levels(%{level: level, current_level: current_level}), do: level - current_level

  # Hopefully correct interpretation of the rules:
  #
  # 1. On each level except the last, draw 2^n-1 branches, where n is the number
  #    of remaining levels.
  #
  # 2. At the ending point of branch from 1, repeat recursively by turning
  #    +/- 45 degrees from the previous direction.
  #
  # 3. When on the last level, draw a leaf at the given angle.
  defp generate_recursive(%{level: level, current_level: level} = state) do
    state
    |> extend(@leaf_length)
    |> draw_segment
  end

  # Non-last zero -> draw branch, and spawn +/- 45 degree calculations
  defp generate_recursive(state) do
    state = state |> extend(:math.pow(2, remaining_levels(state) - 1) * @branch_length)

    draw_segment(state)
    :timer.sleep(200)

    # Go forward only if the branch segment is > 0, otherwise no point in
    # computing zero-sized segments.
    unless zero_size_segment?(state) do
      # The branches can be computed independently, so we'll spawn them, but only
      # to some extend (see branch_computation/2).
      [:math.pi/4, -:math.pi/4]
      |> Enum.map(fn(angle) ->
           branch_computation(state, fn ->
             state
             |> inc_level
             |> turn(angle)
             |> generate_recursive
           end)
         end)
      |> Enum.map(&await_computation(&1))
    end

    :ok
  end

  defp zero_size_segment?(state) do
    {x1, y1} = LineSegment.from(state.line_segment)
    {x2, y2} = LineSegment.to(state.line_segment)

    (abs(round(x2 - x1)) == 0 and abs(round(y2 - y1)) == 0)
  end

  # Spawn up to a point to avoid excessive amounts of processes
  defp branch_computation(%{current_level: current_level}, fun) when current_level < 10 do
    Task.async(fun)
  end

  defp branch_computation(_, fun), do: fun.()

  defp await_computation(%Task{} = task) do
    Task.await(task, :infinity)
  end

  defp await_computation(_), do: :ok


  defp extend(state, by) do
    %{state | line_segment: LineSegment.extend(state.line_segment, by)}
  end

  defp turn(state, by) do
    %{state | line_segment: LineSegment.turn(state.line_segment, by)}
  end

  def draw_segment(state) do
    Painter.draw_line(
      state.painter,
      adapt_pos(state, LineSegment.from(state.line_segment)),
      adapt_pos(state, LineSegment.to(state.line_segment))
    )

    :ok
  end

  defp adapt_pos(state, {x, y}) do
    {round(x + state.size/2), round(state.size - y)}
  end
end