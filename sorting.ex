defmodule Sorting do

    def insert(elem, []) do [elem] end
    def insert(elem, [h | t]) when elem < h do
      [elem, h | t]
    end
    def insert(elem, [h | t]) do
      [h | insert(elem, t)]
    end

    ## Insertionsort
    def isort(l) do isort(l, []) end
    def isort([], sorted) do sorted end
    def isort([h | t], acc) do
      isort(t, insert(h, acc))
    end




    ## Merge sort som först splittar ner en lista för att sedan merga dem tillbaka ihop
    def msort([]) do [] end
    def msort([x]) do [x] end
    def msort(l) do
      {left, right} = msplit(l, [], [])
      merge(msort(left), msort(right))
    end

    def merge(left, []) do left end
    def merge([], right) do right end
    def merge([h1 | l1], [h2 | _] = l2) when h1 < h2 do
      [h1 | merge(l1, l2)]
    end
    def merge(l1, [h2 | l2]) do
      [h2 | merge(l1, l2)]
    end

    def msplit([], left, right) do {left, right} end
    def msplit([h | t], left, right) do
      msplit(t, [h | right], left)
    end



    ## Quicksort
  def qsort([]) do [] end
  def qsort([p | l]) do
    {list1, list2} = qsplit(p, l, [], [])
    small = qsort(list1)
    large = qsort(list2)
    append(small, [p | large])
  end

  def qsplit(_, [], small, large) do {small, large} end
  def qsplit(p, [h | t], small, large) do
    if h < p  do
      qsplit(p, t, [h | small], large)
    else
      qsplit(p, t, small, [h | large])
    end
  end

  def append(list1, list2) do
    case list1 do
      [] -> list2
      [h | t] -> [h | append(t, list2)]
    end
  end

    # Quicksort (ADVANCED)
    # Option 3: Enum.partition and function capture

    # Compressed quick sort using the "Enum.partition", quite neat ey?
  def qsort_enum([]) do [] end
  def qsort_enum([head | tail]) do
    {smaller, greater} = Enum.split_with(tail, &(&1 < head))
    qsort_enum(smaller) ++ [head] ++ qsort_enum(greater)
  end






end
