defmodule Log do

  def split(seq) do split(seq, 0, [], []) end
  def split([], l, left, right) do
    [{left, right, l}]
  end
  def split([s], l, [], right) do
    [{[s], right, l}]
  end
  def split([s], l, left, []) do
    [{left, [s], l}]
  end

  def split([s|rest], l, left, right) do
    split(rest, s+l, [s|left], right) ++
    split(rest, s+l, left, [s|right])

  end

  def cost([]) do 0 end
  def cost([_]) do 0 end
  def cost(seq) do cost(seq, 0, [], []) end

  def cost([], l, left, right) do
    l + cost(left) + cost(right)
  end
  def cost([s], l, [], right) do
    s + l + cost(right)
  end
  def cost([s], l, left, []) do
    s + l + cost(left)
  end

  def cost([s|rest], l, left, right) do
    cl = cost(rest, l+s, [s|left], right)
    cr = cost(rest, l+s, left, [s|right])
    if cl < cr do
      cl
    else
      cr
    end
  end

  ## Adding a tree as return value.

  def cast([]) do {0, :na} end
  def cast([s]) do {0, s}end
  def cast(seq) do cast(seq, 0, [], []) end

  def cast([], l, left, right) do
    {cl, sl} = cast(left)
    {cr, sr} = cast(right)
    {cl + cr + l, {sl, sr}}
  end

  def cast([s], l, [], right)  do
    {cr, sr} = cast(right)
    {cr + l + s, {s, sr}}
  end
  def cast([s], l, left, [])  do
    {cl, sl} = cast(left)
    {cl + l + s, {sl, s}}
  end
  def cast([s|rest], l, left, right) do
    {cl, sl} = cast(rest, l+s, [s|left], right)
    {cr, sr} = cast(rest, l+s, left, [s|right])
    if cl < cr do
      {cl, sl}
    else
      {cr, sr}
    end
  end

  def bench(n) do
    for i <- 1..n do
  {t,_} = :timer.tc(fn() -> mcost(Enum.to_list(1..i)) end)
  IO.puts(" n = #{i}\t t = #{t} us")
  end
  end

  def cust([]) do {0, :na} end
  def cust(seq) do
    {c, t, _mem} = cust(Enum.sort(seq), Memo.new())
    #l = length(Memo.to_list(mem))
    #IO.puts("mumber of sequences in memory: #{l}")
    {c, t}
  end


  def check(seq,  mem) do
    case Memo.lookup(mem, seq) do
      nil ->
	       {c, t, mem} = cust(seq, mem)
	        {c, t, Memo.add(mem, seq, {c,t})}
      {c, t} ->
	       {c, t, mem}
    end
  end

  ## Avoid mirror solutions by adding the first element to the left.
  def cust([s], mem) do {0, s, mem}end
  def cust([s|rest], mem) do cust(rest, s, [s], [], mem) end


  def cust([], l, left, right, mem)  do
    {cl, sl, mem} = check(Enum.reverse(left), mem)
    {cr, sr, mem} = check(Enum.reverse(right), mem)
    {cl+cr+l, {sl,sr}, mem}
  end
  # left pile will never be empty
  #def cust([s], l, [], right, mem)  do
  #  {cr, sr, mem} = check(Enum.reverse(right), mem)
  #  {cr + l + s, {s, sr}, mem}
  #end
  def cust([s], l, left, [], mem)  do
    {cl, sl, mem} = check(Enum.reverse(left), mem)
    {cl + l + s, {sl, s}, mem}
  end
  def cust([s|rest], l, left, right, mem) do
    {cl, sl, mem} = cust(rest, l+s, [s|left], right, mem)
    {cr, sr, mem} = cust(rest, l+s, left, [s|right], mem)
    if cl < cr do
      {cl, sl, mem}
    else
      {cr, sr, mem}
    end
  end












end
