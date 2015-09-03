defmodule Painter do
  # Rely on Workex to adaptively batch-process multiple draw requests.
  # Otherwise, we may end up with many requests for small line fragments,
  # which won't perform well.
  use Workex

  def start_link(opts) do
    Workex.start_link(__MODULE__, opts)
  end

  def draw_line(pid, from, to) do
    Workex.push_ack(pid, {from, to})
  end

  def init(opts) do
    {:ok, MainWindow.start(
      opts[:title],
      opts |> adapt_size |> Keyword.take([:size, :pos])
    )}
  end

  defp adapt_size(opts) do
    Keyword.merge(opts, size: {opts[:size], opts[:size] + 50})
  end

  def handle(lines, window) do
    MainWindow.draw_lines(window, lines)
    {:ok, window}
  end
end