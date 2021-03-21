defmodule Newbasic do


  def emul() do

    prog = [  [0,{:addi,1,0,10}],
              [1,{:addi,3,0,1}],
              [2,{:out, 3}],
              [3,{:addi,1,1,-1}],
              [4,{:addi,4,3,0}],
              [5,{:add,3,2,3}],
              [6,{:out, 3}],
              [7,{:beq, 1,0,3}],
              [8,{:addi, 2,4,0}],
              [9,{:beq, 0,0,-6}],
              [10,{:halt}]
            ]


    reg = [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}]
    pc = 0
    emul(prog, reg, [], pc, prog)
  end

  def emul([ [pc,{:halt}]|_], reg, acc, pc, _prog) do {:terminated, reg, reverse(acc), pc} end

  def emul([ [pc,{:beq, s1, s2, count}] | rest], reg, acc, pc, prog) do
    v1 = lookup(s1, reg)
    v2 = lookup(s2, reg)
    if v1 == v2 do
    emul(prog, reg, acc, pc+count, prog)
  else
    emul(rest, reg, acc, pc+1, prog)
  end
  end

  def emul([ [pc,h] | rest], reg, acc, pc, prog) do
    {newreg, acc} = calc(h, reg, acc)
    emul(rest, newreg, acc, pc+1, prog)
  end
  def emul([ [_,_] | rest], reg, acc, pc, prog) do
    emul(rest, reg, acc, pc, prog)
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

end
