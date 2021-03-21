defmodule Basic do


  def emul() do

    prog = [  {0,:addi,1,0,10},
              {1,:addi,3,0,1},
              {2,:out, 3},
              {3,:addi,1,1,-1},
              {4,:addi,4,3,0},
              {5,:add,3,2,3},
              {6,:out, 3},
              {7,:beq, 1,0,3},
              {8,:addi, 2,4,0},
              {9,:beq, 0,0,-6},
              {10:halt}
            ]


    reg = [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}]
    pc = 0
    emul(prog, reg, [], pc)
  end

  def emul([{:halt}|_], reg, acc, pc) do {:terminated, reg, reverse(acc), pc} end

  def emul([{:beq, s1, s2, count}| rest], reg, acc, pc) do
    v1 = lookup(s1, reg)
    v2 = lookup(s2, reg)
    if v1 == v2 do
    emul(rest, reg, acc, pc+count)
  else
    emul(rest, reg, acc, pc)
  end
  end

  def emul([h | rest], reg, acc, pc) do
    {newreg, acc} = calc(h, reg, acc)
    emul(rest, newreg, acc, pc+1)
  end


  def calc({:add, d, s1, s2}, reg, acc) do
    v1 = lookup(s1, reg)
    v2 = lookup(s2, reg)
    {put_ele(d, reg, v1+v2), acc}
  end

  def calc({:addi, d, s1, imm}, reg, acc) do
    v1 = lookup(s1, reg)
    {put_ele(d, reg, v1+imm), acc}
  end


  def calc({:out, s}, reg, acc) do
    val = lookup(s, reg)
    {reg, [val|acc]}
  end


  def put_ele(d, [{d, _} | rest], res) do [{d, res} |rest] end
  def put_ele(d, [{h, v} | rest], res) do [{h,v} | put_ele(d, rest, res)] end


  def lookup(s, [{s, val}| _]) do val end
  def lookup(s, [{_, _} | rest]) do lookup(s, rest) end

  def reverse(lst) do reverse(lst, []) end
  def reverse([], acc) do acc end
  def reverse([h|t], acc) do
    reverse(t, [h|acc])
  end


  def high([], _, _) do [] end
  def high([h | rest], val, fnc) do
   case fnc.(h, val) do
     {:ok, acc} ->
       [h | high(rest, acc, fnc)]
     :no ->
       []
   end
  end

  def sum(lst, n) do
    fnc = (fn(x,y) ->
      if (y-x)>0 do
        {:ok, y-x}
      else
        :no
      end
    end)
    high(lst, n, fnc)
  end






end
