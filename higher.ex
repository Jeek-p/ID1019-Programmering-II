defmodule High do


  ## funktioner för att hantera kortlek

  @type suite :: :spade | :heart | :diamond | :club
  @type value :: 2..14
  @type card :: {:card, suite, value}

  def test() do
    deck = [{:card, :heart, 5}, {:card, :club, 2}, {:card, :diamond, 9}, {:card, :heart, 8}, {:card, :spade, 10}, {:card, :club, 8}]
    # sort(deck)
    sort(deck, fn (h1, h2) -> lt(h1, h2) end)
  end

  ## funktion för att kolla om första är mindre än andra

  def lt({:card, s, v1}, {:card, s, v2}) do v1 < v2 end
  def lt({:card, :club, _}, _) do true end
  def lt({:card, :diamond, _}, {:card, :heart, _}) do true end
  def lt({:card, :diamond, _}, {:card, :spade, _}) do true end
  def lt({:card, :spade, _}, {:card, :heart, _}) do true end
  def lt({:card, _, _}, {:card, _, _}) do false end

  def sort([]) do [] end
  def sort([n]) do [n] end
  def sort(list) do
    {a, b} = split(list)
    merge(sort(a), sort(b))
  end

  ## tail rek split blir dock blandad ordning
  def split(list) do split(list, [], []) end
  def split([], left, right) do {left, right} end
  def split([h|t], left, right) do split(t, [h|right], left) end

  def merge([], right) do right end
  def merge(left, []) do left end
  def merge([h1|t1]=s1, [h2|t2]=s2) do
    case lt(h1, h2) do
      true -> [h1 | merge(t1, s2)]
      false -> [h2 | merge(s1, t2)]
  end
  end



  {register,pc} = inst({:addi,1,0,10,register},pc)
  {register,pc} = inst({:addi,3,0,1,register},pc)
  {register,output,pc} = inst({:out, 3,register,output},pc)
  {register,pc} = inst({:addi,1,1,-1,register},pc)
  {register,pc} = inst({:addi,4,3,2,register},pc)
  {register,pc} = inst({:add,4,3,2,register},pc)
  {register,output,pc} = inst({:out, 3,register,output},pc)








  ## Higher order funktioner

  # Atoms = {a, b, c, . . . }
  # Closures = {<p:s:θ> | p ∈ Parameters ∧ s ∈ Sequences ∧ θ ∈ Environments }
  # Structures = Closures ∪ Atoms ∪ { {a, b} |a ∈ Structures ∧ b ∈ Structures }

  # <function> ::= ’fn’ ’(’ <parameters> ’)’ ’->’ <sequence> ’end’

  # <parameters> ::= ’ ’ | <variables>

  # <variables> ::= <variable> | <variable> ’,’ <variables>

  # <application> ::= <expression> ’.(’ <arguments> ’)’

  # <arguments> ::= ’ ’ | <expressions>

  # <expressions> ::= <expression> | <expression> ’,’ <expressions>


  ## båda foldr finns i List funktioner/module

  ## inte tail rek utan gör op på vägen upp
  ## [1,2,3,4], 0, +
  ## (1 +(2 +(3 +(4 +0)))
  def foldr([], acc, _op) do acc end
  def foldr([h|t], acc, op) do
   op.(h, foldr(t, acc, op))
  end

  ## tail rek där vi op på vägen ner
  ## [1,2,3,4], 0, +
  ## (4 +(3 +(2 +(1 +0)))
  def foldl([], acc, _op) do acc end
  def foldl([h|t], acc, op) do
   foldl(t, op.(h, acc), op)
  end



  def appendr(l) do
    f = fn(e,a) -> e ++ a end
    foldr(l, [], f)
  end

  def appendl(l) do
    f = fn(e,a) -> a ++ e end
    foldl(l, [], f)
  end

  ## finns i Enum funktioner/module

  ## returnerar list of f.(x) av varje element i enumeration
  def map([], _op) do [] end
  def map([h|t], op) do
    [op.(h) | map(t, op)]
  end


  ## filtrera lista bereoende på funktion
  def filter([], _ ) do [] end
  def filter([h|t], op) do
    if op.(h) do
      [h | filter(t, op)]
    else
      filter(t, op)
    end
  end

  ## Polymorfism genom att skicka med en op och kan då sort och merga olika beroende på fn
  def sort([], _) do [] end
  def sort([n], _) do [n] end
  def sort(list, op) do
    {a, b} = split(list)
    merge(sort(a, op), sort(b, op), op)
  end

  def merge([], right, _) do right end
  def merge(left, [], _) do left end
  def merge([h1|t1]=s1, [h2|t2]=s2, op) do
    if op.(h1, h2) do
      [h1 | merge(t1, s2, op)]
    else
      [h2 | merge(s1, t2, op)]
  end
  end





























end
