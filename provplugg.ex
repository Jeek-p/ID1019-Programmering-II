defmodule Provplugg do

  ## tenta 2020-03-09

  #1
  def toggle([a,b|rest]) do [b,a|toggle(rest)] end
  def toggle(rest) do rest end

  #2
  @type stack() :: [any()]

  def push(obj, stack) do [obj|stack] end
  def pop([]) do :no end
  def pop([h|rest]) do {:ok, h, rest} end

  #3
  def flatten([h|tail]) do flatten(h) ++ flatten(tail) end
  def flatten([]) do [] end
  def flatten(item) do [item] end


  #4
  def index(lst) do index(lst, 0) end
  def index([hd|tail], h) when hd > h do
    index(tail, h+1)
  end
  def index(_, h) do h end


  #5 returnera det som finns i löven i ett träd.... : @type tree() :: :nil | {:node, tree(), tree()} | {:leaf, any()}
  def compact(:nil) do :nil end
  def compact({:leaf, value}) do {:leaf, value} end
  def compact({:node, tv, th}) do
     nv = compact(tv)
     nh = compact(th)
     combine(nv,nh)
  end

  def combine({:leaf, value}, :nil) do {:leaf, value} end
  def combine(:nil, {:leaf, value}) do {:leaf, value} end
  def combine({:leaf, value}, {:leaf, value}) do {:leaf, value} end
  def combine(tv, th) do {:node, tv, th} end

  #7 räkna ut nästa primtal med Eratostehenes såll algo. om rem av talet n och nästa p == 0 så är det ej ett prim
  def primes(n) do
    fn() -> {:ok, 2, fn() -> sieve(2, fn() -> next(3) end, n) end} end

  end
  def next(n) do
    {:ok, n, fn() -> next(n+1) end}
  end
  def sieve(p, f, n) do
    {:ok, n, f} = f.()
    if rem(n, p) == 0 do
      sieve(p, f, n-1)
    else
      {:ok, n, fn() -> sieve(n, fn() -> sieve(p,f, n-1) end) end}
    end
  end
  def sieve(p, f, 0) do
    {:ok, n, f} = f.()
    if rem(n, p) == 0 do
      sieve(p, f, n-1)
    else
      {:ok, n, fn() -> sieve(n, fn() -> sieve(p,f, n-1) end) end}
    end
  end


  #8 en linjär och bätttre flatten
  def flatt([]) do [] end
  def flatt([[]|rest]) do flatt(rest) end
  def flatt([[head|tail]|rest]) do flatt([head, tail | rest]) end
  def flatt([elem|rest]) do [elem|flatt(rest)] end


  #9 paralell map  ... ([1,2,3,4], fn(x) -> x + 2 end)
  def pmap(lst, fnc) do
    refs = Enum.map(lst, parallell(fnc))
    Enum.map(refs, collect())
  end

  def parallell(fnc) do
    me = self()
    fn(x) ->
      ref = make_ref()
      spawn(fn() ->
        res = fnc.(x)
        send(me, {:ok, ref, res})
      end)
      ref
    end
  end

  def collect() do
    fn(r) -> receive do {:ok, ^r, res} -> res end end
  end







  #2019-06-05

  #1 droppar varje nte tal i en lista
  def drop(lst, n) do
    drop(lst, n, 1, [])
  end
  def drop([h|tail], n, cnt, acc) do
    if cnt == n do
      drop(tail, n, 1, acc)
    else
      drop(tail, n, cnt+1, acc++[h])
    end
  end
  def drop([], _, _, acc) do acc end

  #2 rotera en list av längd l n steg
  def rotate(lst, n) do rotate(lst, n, []) end
  def rotate([elem|rest], n, first) do
    rotate(rest, n-1, [elem|first])
  end
  def rotate(rest, 0, first) do
    Recursion.append(rest, Recursion.reverse(first))
  end


  #3 hitta nth värdet i ett träd, först djupet vänster ...@type tree() :: {:leaf, any()} | {:node, tree(), tree()}
  def nth(1, {:leaf, val}) do
    {:found, val}
  end
  def nth(n, {:leaf, _}) do
    {:cont, n-1}
  end
  def nth(n, {:node, tv, th}) do
    case nth(n, tv) do
      {:found, val} -> {:found, val}
      {:cont, k} -> nth(k, th)
    end
  end


  #4 polsk notations kalkylator
  def hp35(lst) do hp35(lst, []) end
  def hp35([], acc) do acc end
  def hp35([h|rest], acc) do
    case h do
      :add -> hp35(rest, [add(acc)])
      :sub -> hp35(rest, [sub(acc)])
      _ -> hp35(rest, acc++[h])
    end
  end

  def sub([]) do 0 end
  def sub([h|tail]) do h - sub(tail) end

  def add([]) do 0 end
  def add([h|tail]) do h + add(tail) end


  #5 Pascals triangel
  def pascal(1) do [1] end
  def pascal(n) do
    [1 | next(pascal(n-1))]
  end

  def next([1]) do [1] end
  def next([a|rest]) do
    [b|_] = rest
    [a+b | next(rest)]
  end

  #7 transformera ett träd..@type tree() :: {:node, any(), tree(), tree()} | :nil...@spec trans(tree(), (any() -> any()))

  def trans(:nil, _) do :nil end
  def trans({:node, val, tv, th}, fnc) do
    {:node, fnc.(val), trans(tv,fnc), trans(th,fnc)}
  end

  def remit(tree, n) do trans(tree, fn(v) -> rem(v,n) end) end


  #9 hp35 miniräknare med processer
  def start() do
    spawn(fn() -> hp35([]) end)
  end

  def hp35(stack) do
    receive do
      {:add, from} ->
        [x1, x2 |stack] = stack
        res = x1 + x2
        send(from, {:res, res})
        hp35([res|stack])
        {:int, int} ->
          hp35([int|stack])
      end
  end

  def testhp() do
    hp = start()
    send(hp, {:int, 4})
    send(hp, {:int, 3})
    send(hp, {:add, self()})
    receive do
      {:res, res} ->
        res
    end
  end


  #2019-03-08

  #1 decode tuple
  def decode([]) do [] end
  def decode([{elem, 0}|code]) do
    decode(code)
  end
  def decode([{elem, n}|code]) do
    [elem | decode([{elem, n-1} | code])]
  end


  #2 zip två listor till en tuple
  def zip([], []) do [] end
  def zip([h1|t1], [h2|t2]) do [{h1,h2} | zip(t1, t2)] end


  #3 balansera träd .. @spec tree() :: :nil | {:node, any(), tree(), tree()}
  def balance(:nil) do {0, 0} end
  def balance({:node, _, left, right}) do
    {dl, il} = balance(left)
    {dr, ir} = balance(right)
    #depth = max(dl, dr) + 1
    #imbalance = max(max(il, ir), abs(dl-dr))
    #{depth, imbalance}
  end


  #4 Evaluera uttryck
  def eval({:add, x, y}) do eval(x) + eval(y) end
  def eval({:mul, x, y}) do eval(x) * eval(y) end
  def eval({:neg, x}) do - eval(x) end
  def eval(x) do x end


  #5 gray kodning binära koder
  def grey(0) do [[]] end
  def grey(n) do
    lst = grey(n-1)
    revcop = Recursion.reverse(lst)
    zero = update(lst, 0)
    one = update(lst, 1)
    mix = Recursion.append(zero, one)
    mix
  end

  def update([], _) do [] end
  def update([h|rest], n) do [[n|h] | update(rest,n)] end


  #7 ström av fib
  def fib() do
    fn() -> fib(1,0) end
  end
  def fib(f1, f2) do
    {:ok, f1, fn() -> fib(f1+f2, f1) end}
  end

  def take(fnc, 0) do
    {:ok, [], fnc}
  end
  def take(fnc, n) do
    {:ok, first, cont} = fnc.()
    {:ok, rest, cont} = take(cont, n-1)
    {:ok, [first|rest], cont}
  end


  #8 fackulitet och facl returnerar en lista med fack med linjär tidskomplx
  def fac(1) do 1 end
  def fac(n) do
    n * fac(n-1)
  end

  def facl(1) do [1] end
  def facl(n) do
    rest = facl(n-1)
    [f | _] = rest
    [n*f | rest]
  end


  #9 parallell hantering men som skrivs om så parallell hårdvara kan utnyttjas
  def start(user) do
    {:ok, spawn(fn() -> proc(user) end)}
  end

  def proc(user) do
    receive do
      {:process, task} ->
        #done = doit(task)
        #send(user, done)
        proc(user)
        :quit ->
          :ok
        end
      end


  def start(user) do
    collector = spawn(fn() -> collector(user, 0) end)
    {:ok, spawn(fn() -> para(collector, 0) end)}
  end

  def para(collector, n) do
    receive do
      {:process, task} ->
        spawn(fn() ->
        #done = doit(task)
        #send(collector, {:done, n, done})
      end)
        para(collector, n+1)
        :quit ->
          send(collector, :quit)
          :ok
        end
    end

    def collector(user, n) do
      receive do
        {:done, ^n, done} ->
          send(user, done)
          collector(user, n+1)
          :quit ->
            :ok
          end
    end


    #2018-06-07

    #4 lista med :fizz ist för nr vid delbara med 3/5

    def fizzbuzz(n) do fizzbuzz(1, n+1, 1, 1) end
    def fizzbuzz(n, n, _, _) do [] end
    def fizzbuzz(n, m, 3, 5) do [:fizzbuzz | fizzbuzz(n, m, 1, 1)] end
    def fizzbuzz(n, m, 3, f) do [:fizz | fizzbuzz(n, m, 1, f+1)] end
    def fizzbuzz(n, m, t, 5) do [:buzz | fizzbuzz(n, m, t+1, 1)] end


    #5 hyfsat balanserat träd max 1 @tree :: nil | {:node, tree(), tree()}

    def fairly(nil) do {:ok, 0} end
    def fairly({:node, left, right}) do
      case fairly(left) do
        {:ok, l} ->
          case fairly(right) do
            {:ok, r} ->
              if abs(l-r) < 2 do
                {:ok, 1 + max(l,r)}
              else
                :no
              end
              :no -> :no
          end
          :no -> :no
      end
    end


  #6 en riktad graf ..   @type graph :: {:node, any(), [graph()]} | nil

  def search(_, nil) do :fail end
  def search(e, {:node, e, _}) do :found end
  def search(e, {:node, _, paths}) do
    List.foldl(paths,
    :fail,
    fn(p,a) ->
    case a do
    :found -> :found
      :fail ->
      search(e, p)
      end
    end)
  end


  #7 process beskrivning
  def dillinger() do spawn(fn() -> nyc() end) end
  def nyc() do
    IO.puts("Hey Jim")
    receive do
      :knife -> knife()
    end
  end

  def knife() do
    receive do
      :fork -> fork()
    end
  end

  def fork() do
    receive do
      :bottle -> bottle()
    end
  end

  def bottle() do
    receive do
      :cork -> nyc()
    end
  end


  #8 parallell foldp
  def foldp([x], _) do x end
  def foldp(lst, fnc) do
    {l1, l2} = split(lst, [], [])
    me = self()
    spawn(fn() ->  res = foldp(l1, fnc); send(me, {:res, res}) end)
    spawn(fn() ->  res = foldp(l2, fnc); send(me, {:res, res}) end)
    receive do
      {:res, r1} ->
        receive do
          {:res, r2} ->
            fnc.(r1,r2)
          end
    end
  end

  def split([], lst1, lst2) do {lst1, lst2} end
  def split([h|t], lst1, lst2) do
    split(t, [h|lst2], lst1)
  end


  #9 Nätverk för sortering, jämförande process
  def comp(low, high) do
    spawn(fn() -> comp(0, low, high) end)
  end

  def comp(n, low, high) do
    receive do
      {:done, ^n} ->
        send(low, {:done, n})
        send(high, {:done, n})
      {:epoch, ^n, x1} ->
        receive do
          {:epoch, ^n, x2} ->
            if x1 < x2 do
              send(low, {:epoch, n, x1})
              send(high, {:epoch, n, x2})
            else
              send(low, {:epoch, n, x2})
              send(high, {:epoch, n, x1})
            end
          comp(n+1, low, high)
        end
    end
  end


  #10 sorter
  def start(lst) do
    spawn(fn() -> init(lst) end)
  end

  def init(lst) do
    netw = setup(lst)
    #sorter = sort(0, netw)
  end

  def sorter(n, netw) do
    receive do
      {:sort, epoch} ->
        #(each(zip(netw, this)),
          #fn({cmp, x}) -> send(cmp, {:epoc, n, x}) end)
          sorter(n+1, netw)
        #:done ->
          #each(netw, fn(cmp) -> send(cmp, {:done, n}) end)
    end
  end

  #11 setup/2
  def setup(lst) do
    n = length(lst)
    setup(n, lst)
  end

  def setup(2, [s1, s2]) do
    cmp = comp(s1,s2)
    [cmp, cmp]
  end


  #12 merge för processidentifierare
  def merge(2, [s1, s2]) do
    cmp1 = comp(s1, s2)
    [cmp1, cmp1]
  end


  #13 cross
  def cross(low, high) do
    cross(low, reverse(high), [])
  end
  def cross([], [], crossed) do
    {reverse(crossed), crossed}
  end
  def cross([l|low], [h|high], crossed) do
    cmp = comp(l, h)
    cross(low, high, [cmp | crossed])
  end


  #14 setup för n = 4
  def setup(4, [s1,s2,s3,s4]) do
    [m1, m2] = merge(2, [s1,s2])
    [m3, m4] = merge(2, [s3,s4])

    {[c1, c2], [c3, c4]} = cross([m1, m2], [m3, m4])

    [i1, i2] = setup(2, [c1, c2])
    [i3, i4] = setup(2, [c3, c4])

    [i1, i2, i3, i4]
  end


  #2018-03-13

  #4 rekursion binärt träd ... @type tree :: {:node, integer(), tree(), tree()} | nil
  def sum(nil) do 0 end
  def sum({:node, val, left, right}) do
    val + sum(left) + sum(right)
  end

  #5 svansrek append genom impletering av reverse svansrek
  def append(lst1, lst2) do
    reverse(reverse(lst1), lst2)
  end

  def reverse(lst) do reverse(lst, []) end
  def reverse([], acc) do acc end
  def reverse([h|t], acc) do
    reverse(t, [h|acc])
  end


  #6 processbeskrivning
  def start() do
    spawn(fn() -> closed() end)
  end

  def closed() do
    receive do
      2 -> two()
      _ -> closed()
  end
end

  def two() do
    receive do
      2 -> two()
      #4 -> four()
      _ -> closed()
    end
  end


  #7 parallel summering av tal i ett binärt träd ... @type tree :: {:node, tree(), tree()} | {:leaf, integer()}
  def sum({:leaf, val}) do val end
  def sum({:node, left, right}) do
    me = self()
    spawn(fn() -> res = sum(left); send(me, {:res, res}) end)
    spawn(fn() -> res = sum(right); send(me, {:res, res}) end)
    receive do
      {:res, res1} ->
        receive do
          {:res, res2} ->
            {:ok, res1+res2}
        end
    end
  end

  #8 heap ... @type heap :: {:heap, integer(), heap(), heap()} | nil
  # @spec new() :: heap()

  def new() do nil end

  #@spec add(heap(), integer()) :: heap()

  def add(nil, value) do {:heap, value, nil, nil} end
  def add({:heap, val, left, right}, v) when val > v do
    {:head, val, add(right, v), left}
  end
  def add({:heap, val, left, right}, v) do
    {:heap, v, add(right, val), left}
  end


  # @spec pop(heap()) :fail | {:ok, integer(), heap()}

  def pop(nil) do :fail end
  def pop({:heap, val, left, nil}) do {:ok, val, left} end
  def pop({:heap, val, nil, right}) do {:ok, val, right} end
  def pop({:heap, val, left, right}) do
    {:heap, v1, _, _} = left
    {:heap, v2, _, _} = right

    if v1 < v2 do
      {:ok, _, rest} = pop(right)
      {:ok, val, {:heap, v2, left, rest}}
    else
      {:ok, _, rest} = pop(left)
      {:ok, val, {:heap, v1, rest, right}}
    end
  end


  #@spec swap(heap(), integer()) {:ok, integer(), heap()}

  def swap(nil, v) do {:ok, v, nil} end
  def swap({:heap, k, left, right}, v) when k > v do
    {:ok, v, left} = swap(left, v)
    {:ok, v, right} = swap(right, v)

    {:ok, k, {:heap, v, left, right}}
  end
  def swap(heap, v) do
    {:ok, v, heap}
  end

  # ny add för generella element med en cmp funktion
  #@type cmp() :: (any(), any()) -> bool())
  #@spec add(heap(), any(), cmp()) :: heap()

  def add(nil, v, _) do {:heap, v, nil, nil} end
  def add({:heap, k, left ,right}, v, cmp) do
    if cmp.(v, k) do
      {:heap, k, add(right, v, cmp), left}
    else
      {:heap, v, add(right, k, cmp), left}
    end
  end


  #2017-06-07

  #2 Tar bort x och multiplicerar med y i en lista (l)
  def transf(_, _, []) do [] end
  def transf(x, y, [x|rest]) do transf(x, y, rest) end
  def transf(x, y, [h|rest]) do [y*h | transf(x, y, rest)] end


  #3 göra om sum så den blir svansrek
  def sum(lst) do sum(lst, 0) end
  def sum([], acc) do acc end
  def sum([h|rest], x) do sum(rest, h+x) end


  #4 hitta minsta tal i ett träd... @type tree :: nil | {:node, value(), tree(), tree()}
  def min(:nil) do :inf end
  def min({:node, val, left, right}) do
    ml = min(left)
    mr = min(right)
    v = min(ml, mr)
    if val < v do
      val
    else
      v
    end
  end


end
