defmodule Recursion do

  def prod(m, n) do

    case m do
      0 -> 0
      _ -> n + prod((m-1), n)
    end
  end





  def fib(n) do
    if n == 0 do
      0
    else
      if n == 1 do
        1
      else
        fib(n-1) + fib(n-2)
      end
    end
  end

  def ackerman(m,n) do

    if  m == 0 do
      n + 1
    else
      if m > 0 and n == 0 do
        ackerman(m-1,1)
      else
      ackerman(m-1, ackerman(m, n-1))
    end
    end
  end

  def tak(n) do

    case n do
      [] -> :error
      [h | t] -> t
    end
  end

  def drp([_ | tail]) do
    tail
  end

  def len(l) do

    case l do
      [] -> 0
      [head | tail] -> 1 + len(tail)
    end
  end



  def sum(list) do

    case list do
      [] -> 0
      [head | tail] -> head + sum(tail)
    end
  end

  def sumtailrec(list) do sumtailrec(list, 0) end

  def sumtailrec([], s) do s end

  def sumtailrec([h | t], s) do
    sumtailrec(t, h+s)
  end

  def dup(list) do
    dup(list, [])
  end

  def dup([], acc) do
    acc
  end

  def dup([head | tail], acc) do
    acc = acc ++ [2*head]
    dup(tail, acc)
  end


  def add(x, list) do
    [head | tail] = list
    if x != head do
      add(x, tail, list)
    else
      IO.puts "Element already in the list"
    end
  end

  def add(x, [], newList) do
    newList ++ [x]
  end

  def add(x, [head | tail], oldList) do

    if x != head do
      add(x, tail, oldList)
    else
      IO.puts "Element already in the list"
    end
  end


  def remove(x, list) do
    [head | tail] = list
    if x == head do
      remove(x, tail)
    else
      remove(x, tail, [head])
    end
  end

  def remove(x, [head | tail], list) do

    if x == head do
      remove(x, tail, list)
    else
      list = list ++ [head]
      remove(x, tail, list)
    end
  end

  def remove(x, [], list) do
    list
  end


  def unique([head | tail]) do

    unique(tail, [head])
  end

  defp unique([head | tail], checked) do

    [head_c | tail_c] = checked

    if head != head_c do
      unique(head, tail_c, tail, checked)
    else
      unique(tail, checked)
    end
  end

  defp unique(head, [h | t], tail, checked) do

    if head != h do
      unique(head, t, tail, checked)
    else
      unique(tail, checked)
    end
  end

  defp unique([], checked) do
    checked
  end


  defp unique(head,[], tail, checked) do
    checked = checked ++ [head]
    unique(tail, checked)
  end


  def appendpro([], list2) do
    list2
  end

  def appendpro([h | t], list2) do
    list = appendpro(t, list2)
    [h | list]
  end

  def append(list1, list2) do
    appendrev(reverse(list1), list2)
  end

  def appendrev([], list2) do
    list2
  end

  def appendrev([h | t], list2) do
    appendrev(t, [h | list2])
  end

  def reverse(l) do
  reverse(l, [])
  end

  def reverse([], r) do r end

  def reverse([h | t], r) do
  reverse(t, [h | r])
  end


  def nreverse([]) do [] end

  def nreverse([h | t]) do
  r = nreverse(t)
  append(r, [h])
  end




  def bench() do
  ls = [16, 32, 64, 128, 256, 512]
  n = 100
  # bench is a closure: a function with an environment.
  bench = fn(l) ->
    seq = Enum.to_list(1..l)
    tn = time(n, fn -> nreverse(seq) end)
    tr = time(n, fn -> reverse(seq) end)
    :io.format("length: ~10w  nrev: ~8w us    rev: ~8w us~n", [l, tn, tr])
  end

  # We use the library function Enum.each that will call
  # bench(l) for each element l in ls
  Enum.each(ls, bench)
  end

  # Time the execution time of the a function.
  def time(n, fun) do
  start = System.monotonic_time(:milliseconds)
  loop(n, fun)
  stop = System.monotonic_time(:milliseconds)
  stop - start
  end

  # Apply the function n times.
  def loop(n, fun) do
  if n == 0 do
    :ok
  else
    fun.()
    loop(n - 1, fun)
  end
  end



  def odd ([]) do
    []
  end

  def odd([h | t]) do
    if rem(h,2) == 1 do
      [h | odd(t)]
    else
      odd(t)
    end
  end


  def even ([]) do [] end

  def even([h | t]) do
    if rem(h,2) == 0 do
      [h | even(t)]
    else
      even(t)
    end
  end

  def odd_n_even1(list) do
    o = odd(list)
    e = even(list)
    {o, e}
  end

  def odd_n_even([]) do {[], []} end
  def odd_n_even([h | t]) do
    {o, e} = odd_n_even(t)

    if rem(h, 2) == 1 do
      {[h|o], e}
    else
      {o, [h|e]}
    end
  end

  def odd_pro_even(list) do odd_pro_even(list, [], []) end
  def odd_pro_even([h|t], odd, even) do
    if rem(h,2) == 1 do
      odd_pro_even(t, [h|odd], even)
    else
      odd_pro_even(t, odd, [h|even])
    end
  end

  def odd_pro_even([], odd, even) do {odd, even} end



  def flat([]) do [] end
  def flat([h|t]) do
    h ++ flat(t)
  end


end
