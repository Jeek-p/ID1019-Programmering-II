defmodule Btree do



  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end

  def member(elem, {:node, elem, _, _}) do :yes end
  def member(elem, {:node, e, left, _}) when elem < e do
    member(elem, left)
  end
  def member(elem, {:node, _, _, right}) do
    member(elem, right)
  end


  def insert(elem, :nil) do {:node, elem, :nil, :nil} end
  def insert(elem, {:leaf, e}) when elem < e do
    {:node, e, {:leaf, elem}, :nil}
  end
  def insert(elem, {:leaf, e}) do
    {:node, e, :nil, {:leaf, elem}}
  end
  def insert(elem, {:node, e, left, right}) when elem < e do
    {:node, e, insert(elem, left), right}
  end
  def insert(elem, {:node, e, left, right})  do
    {:node, e, left, insert(elem, right)}
  end


  def delete(e, {:leaf, e}) do  {:leaf, :nil}  end
  def delete(e, {:node, e, :nil, right}) do right end
  def delete(e, {:node, e, left, :nil}) do left end
  def delete(e, {:node, e, left, right}) do
   {:ok, big} = largest(left)
   deleted = delete(big, left)
   {:node, big, deleted, right}
 end
 def delete(e, {_, v, left, right}) when e < v do
    {:node, v,  delete(e, left),  right}
  end
  def delete(e, {_, v, left, right})  do
    {:node, v,  left, delete(e, right)}
  end

  def largest({:node, _, _, right}) do
    largest(right)
  end
  def largest({:leaf, e}) do
    {:ok, e}
  end


end
