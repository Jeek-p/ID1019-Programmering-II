defmodule Cmplx do


  def new(r,i) do
    {{:re,r}, {:im, i}}
  end

  def add({{:re,r1},{:im, i1}},{{:re,r2},{:im, i2}}) do
    {{:re,r1+r2},{:im, i1+i2}}
  end

  def sqr({{:re,r},{:im, i}}) do
    {{:re,(r*r)-(i*i)},{:im,(2*r*i)}}
  end

  def abs({{:re,r},{:im, i}}) do
    :math.sqrt( ((r*r) + (i*i)) )
  end



end
