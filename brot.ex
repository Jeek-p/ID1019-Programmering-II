defmodule Brot do

  def mandelbrot(c, m) do
  z0 = Cmplx.new(0, 0)
  i = 0
  tst(i, z0, c, m)
  end

  def tst(i, _, _, m) when i > m do 0 end

  def tst(i, z0, c, m) do
    z0 = Cmplx.sqr(z0)
    i = i+1
    z1 = Cmplx.add(z0, c)

    if Cmplx.abs(z1) > 2 do
      i
    else
      tst(i, z1, c, m)
    end
  end




end
