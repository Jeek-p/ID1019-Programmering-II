defmodule Tree do





  ## member i löv
  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(elem, {:node, elem, _, _}) do :yes end
  ## Ordnat träd
  def member(elem, {:node, e, left, right}) do
    if elem < e do
    member(elem, left)
    else
      member(elem, right)
    end
  end
  ## Icke ordnat träd
  def member111(elem, {:node, _, left, right}) do
    case member111(elem, left) do
      :yes -> :yes
      :no -> case member111(elem, right) do
              :yes -> :yes
              :no -> :no
            end
    end
  end



  ## Ordnade tröd med tillhörande value
  def lookup(_, :nil) do :no end

  def lookup(key, {:node, key, value, _, _}) do {:value, value} end

  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
    lookup(key, left)
    else
      lookup(key, right)
    end
  end


  def modify(_, _, :nil) do :nil end

  def modify(key, value, {:node, key, _, left, right}) do
    {:node, key, value, left, right}
  end

  def modify(key, value, {:node, k, v, left, right}) do
    if key < k do
    {:node, k, v, modify(key, value, left), right}
    else
    {:node, k, v, left, modify(key, value, right)}
    end
  end


  def insert(key, value, :nil) do {:node, key, value, :nil, :nil} end
  def insert(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, insert(key, value, left), right}
    else
      {:node, k, v, left, insert(key, value, right)}
    end
  end


  def delete(key, {:node, key, _, :nil, :nil}) do :nil end
  def delete(key, {:node, key, _, left, :nil}) do left end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, right}) do
    {:ok, big, bigv} = largest(left)
    deleted = delete(big, left)
    {:node, big, bigv, deleted, right}
  end
  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end

  def largest({:node, key, value, _, :nil}) do
    {:ok, key, value}
  end
  def largest({:node, _, _, _, right}) do
    largest(right)
  end

  ## Defineriera data strukturen tree
  @type tree() :: :nil | {:node, atom(), number(), tree(), tree()}

  def new() do :nil end
  def test() do
    t = new()
    t = insert(:one, 1, t)
    t = insert(:two, 2, t)
    t = insert(:three, 3, t)
    t = insert(:four, 4, t)
    t = insert(:five, 5, t)
    t = insert(:six, 6, t)
    t = insert(:seven, 7, t)
    t = insert(:eight, 8, t)
    t
  end






end
