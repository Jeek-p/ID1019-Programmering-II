defmodule Chopstick do

  # spawn id process
  def start do
    stick = spawn_link(fn -> init() end)
    {:stick, stick}
  end

  def init() do
    IO.put("Stick is rdy")
    local({:chopstick, self()})
    available()
  end

  def local(msg) do
    case Process.whereis(:shell) do
      nil ->
  nil
      pid ->
  send(pid, msg)
    end
  end


  def available() do
    receive do
      {:request, from} ->
      send(from, :granted)
      gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return ->
      available()
      :quit -> :ok
    end
  end

  def request({:stick, stick}) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
    end
  end

  def return({:stick, stick}) do
    send(stick, :return)
  end

  def quit ({:stick, stick}) do
    send(stick, :quit)
  end




end
