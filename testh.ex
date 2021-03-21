defmodule Test do

  def sample() do
  'the quick brown fox jumps over the lazy dog
  this is a sample text that we will use when we build
  up a table we will only handle lower case letters and
  no punctuation symbols the frequency will of course not
  represent english but it is probably not that far off'
  end

  def text() do
  'this is something that we should encode'
  end


  def tree(sample) do
    text = text()
    freq = freq(sample)
    sorted = Enum.sort(freq, fn({_, f1}, {_, f2}) -> f1 < f2 end)
    tree = huffman(sorted)
    encoded = encode_table(tree)
    #encod = encode(text, encoded)
    #encod

  end

  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    freq(rest, count_freq(char, freq))
  end

  def count_freq(char, []) do [{char, 1}] end
  def count_freq(char, [{char, f} | tail]) do
    [{char, f+1} | tail]
  end
  def count_freq(char, [head | tail]) do
    [head | count_freq(char, tail)]
  end


  def huffman([{char, _} | []]) do char end
  def huffman([{c1, f1} | [{c2, f2} | tail]]) do
    huffman(insert({{c1, c2}, f1+f2}, tail))
  end

  def insert({c, f}, []) do [{c, f}] end
  def insert({c1, f1}, [{c2, f2} | tail]) when f1 < f2 do
    [{c1, f1}, {c2, f2} | tail]
  end
  def insert({c1, f1}, [{c2, f2} | tail]) do
    [{c2, f2} | insert({c1, f1}, tail)]
  end

  def encode_table(tree) do
      encode_table(tree, [])
  end
  def encode_table({left, right}, visit) do
      encode_table(left, [0 | visit]) ++ encode_table(right, [1 | visit])
  end
  def encode_table(char, visit) do
      [{char, reverse(visit)}]
  end

  ## ej färdig , får fel på clause matching

  def encode([], _) do [] end
  def encode([char | tail], [{char, code} | rest]) do
    code ++ encode(tail, [{char, code} | rest])
  end
  def encode([char | tail], [{char1, code1} | rest]) do
    encode(char, rest)
    encode(tail, [{char1, code1} | rest])
  end


  def reverse(l) do
  reverse(l, [])
  end

  def reverse([], r) do r end

  def reverse([h | t], r) do
  reverse(t, [h | r])
  end




end
