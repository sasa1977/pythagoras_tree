defmodule LineSegment do
  def new(downscale) do
    %{from: {0,0}, angle: :math.pi/2, length: 0, downscale: downscale}
  end

  def from(segment), do: segment.from
  def to(segment) do
    {x, y} = segment.from
    {
      x + (segment.length / segment.downscale) * :math.cos(segment.angle),
      y + (segment.length / segment.downscale) * :math.sin(segment.angle)
    }
  end

  def extend(segment, by) do
    %{segment | length: segment.length + by}
  end

  def turn(segment, by) do
    %{segment | from: to(segment), angle: segment.angle + by, length: 0}
  end
end