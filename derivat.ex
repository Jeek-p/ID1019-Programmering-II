defmodule Derivat do

  @type literals() :: {:num, number()} |{:var, atom()}

  @type expr() :: literals() | {:add, expr(), expr()} | {:mul, expr(), expr()} | {:exp, expr(), literals()}

  ## derivata regler för varje enskild funktion
  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)}
    end

  ## skriver ut en textform av uttrycket
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)} ^ #{pprint(e2)})" end

  ## simply och tillhörande funktion ger en förenkling
  def simply({:add, e1, e2}) do
    simply_add(simply(e1), simply(e2))
  end

  def simply({:mul, e1, e2}) do
    simply_mul(simply(e1), simply(e2))
  end

  def simply({:exp, e1, e2}) do
    simply_exp(simply(e1), simply(e2))
  end

  def simply(e) do e end

  def simply_add({:num, 0}, e2) do e2 end
  def simply_add(e1, {:num, 0}) do e1 end
  def simply_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end
  def simply_add(e1, e2) do {:add, e1, e2} end

  def simply_mul({:num, 0}, _) do {:num, 0} end
  def simply_mul(_, {:num, 0}) do {:num, 0} end
  def simply_mul(e1, {:num, 1}) do e1 end
  def simply_mul({:num, 1}, e2) do e2 end
  def simply_mul({:num, e1}, {:num, e2}) do {:num, e1*e2} end
  def simply_mul(e1, e2) do {:mul, e1, e2} end

  def simply_exp(_, {:num, 0}) do {:num, 1} end
  def simply_exp(e1, {:num, 1}) do e1 end
  def simply_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simply_exp(e1, e2) do {:exp, e1, e2} end

  ## calc beräknar uttryck med vald variabel(v) och nummer(n)
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  def test1() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num,4}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivete: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simply(d))}\n")
    IO.write("Calculated: #{pprint(simply(c))}\n")
  end

  def test2() do
    e = {:add, {:exp, {:var, :x}, {:num, 3}}, {:num,4}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivete: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simply(d))}\n")
    IO.write("Calculated: #{pprint(simply(c))}\n")
  end




end
