defmodule Backend.Scheduler do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, now} = DateTime.now("Asia/Tokyo")
    c = calc_sunday(now)
    IO.puts(c)
    Process.send_after(self(), :work, c)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Backend.Coupons.send_coupon()
    Backend.Users.reset_point()
    schedule_work()
    {:noreply, state}
  end

  defp calc_sunday(now) do
    dif =
      now
      |> DateTime.to_date()
      |> Date.day_of_week()

    with sunday = %Date{} <-
           now
           |> DateTime.to_date()
           |> Date.add(7 - dif) do
      DateTime.diff(
        %DateTime{
          year: sunday.year,
          month: sunday.month,
          day: sunday.day,
          hour: 0,
          minute: 0,
          second: 0,
          time_zone: "Asia/Tokyo",
          utc_offset: now.utc_offset,
          std_offset: now.std_offset,
          zone_abbr: "JST"
        },
        now
      ) * 1000
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 7 * 24 * 60 * 60 * 1000)
  end
end
