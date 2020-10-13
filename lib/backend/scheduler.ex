defmodule Backend.Scheduler do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, calc_sunday())
    {:ok, state}
  end

  def handle_info(:work, state) do
    Backend.Users.reset_point()
    schedule_work()
    {:noreply, state}
  end

  defp calc_sunday() do
    dif =
      Date.utc_today()
      |> Date.day_of_week()

    with {:ok, sunday} <-
           Date.utc_today()
           |> Date.add(7 - dif)
           |> NaiveDateTime.new(~T[00:00:00]) do
      NaiveDateTime.diff(sunday, NaiveDateTime.utc_now())
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 7 * 24 * 60 * 60 * 1000)
  end
end
