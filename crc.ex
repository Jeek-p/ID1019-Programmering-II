defmodule Crc do

  # 1. förläng sekvensen med 000 th
  # 2. koden genereras med Xor av sekvensen och generator
  # 3. om första siffran är 0 så beräkna från resterande xor från första 1 i sekvens

  def crc(sekvens) do

    generator = [1, 0, 1, 1]
    crc = xor(sekvens ++ [0,0,0], generator, generator, [])
    crc
  end

  ## skickar med generatorn genom hela beräkningen och en kopia som inte förändras
  def xor([h|rest], [h|tail], gen, acc) do
    xor(rest, tail, gen, acc++[0])
  end

  def xor([_|rest], [_|tail], gen, acc) do
    xor(rest, tail, gen, acc++[1])
  end

  ## vid varje xor av generatorn så görs en koll på längden om crc koden är = 3 och isåfall funnen
  def xor(sek, [], gen, acc) do
    rest = clean(acc) ++ sek
    length = len(rest)

    cond do
      length < 3 -> zero_add(rest, 3-length)
      length == 3 -> rest
      true -> xor(rest, gen, gen, [])
    end
  end

  ## längdberäkning
  def len([]) do 0 end
  def len([_h|t]) do 1 + len(t) end

  ## rensar bort 0 ur sekvensen
  def clean([]) do [] end
  def clean([0|tail]) do clean(tail) end
  def clean([1|_tail]=acc) do acc end

  ## om koden < 3 så måste 0 adderas tills längden är 3
  def zero_add(rest, 0) do rest end
  def zero_add(rest, zero) do
    resto = [0] ++ rest
    zero_add(resto, zero-1)
  end





end
