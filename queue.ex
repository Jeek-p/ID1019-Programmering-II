defmodule Queue do


  def append(:nil, y) do y end

  def append({:cons, head, tail}, y) do
    {:cons, head, append(tail, y)}
  end





  def new() do {:queue, [], []} end

  def add({:queue, front, back}, elem) do {:queue, front, [elem|back]} end

  def remove({:queue, [], []}) do :error end
  def remove({:queue, [], back}) do
    remove({:queue, Recursion.reverse(back), []})
  end
  def remove({queue, [elem|rest], back}) do
    {:ok, elem, {:queue, rest, back}}
  end

  def reverse(l) do reverse(l, []) end
  def reverse([], r) do r end
  def reverse([h | t], r) do
  reverse(t, [h | r])
  end






















end
