defmodule Huffman do

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

def test do
sample = sample()
tree = tree(sample)
encode = encode_table(tree)
decode = decode_table(tree)
text = text()
seq = encode(text, encode)
decode(seq, decode)
end

def tree(sample) do
  freq = freq(sample)
  tex = text()
  # sorted = Enum.sort(freq, fn({_, f1}, {_, f2}) -> f1 < f2 end)
  sorted = sort(freq)
  tree = huffman(sorted)
  encoded_table = encode_table(tree)
  encod = encode(tex, encoded_table)
  decoded_table = decode_table(tree)
  decod = decode(encod, decoded_table)
  decod

end

# O(n * k) där sample är n stycken tecken med count_freq med k stycken. Göra träd ist med O(log n)
def freq(sample) do freq(sample, []) end
def freq([], freq) do freq end
def freq([char | rest], freq) do
  freq(rest, count_freq(char, freq))
end

## Lägger in freq för varje char
def count_freq(char, []) do [{char, 1}] end
def count_freq(char, [{char, f} | tail]) do
  [{char, f+1} | tail]
end
def count_freq(char, [head | tail]) do
  [head | count_freq(char, tail)]
end

## sorterar efter lägsta freq
def sort(freq) do sort(freq, []) end
def sort([], sorted) do sorted end
def sort([{char, freq} | rest], sorted) do
  sort(rest, insert(char, freq, sorted))
end

def insert(e1, f1, []) do [{e1, f1}] end
def insert(e1, f1, sorted) do
  [first | rest] = sorted
  {_, f2} = first
  if f1 < f2 do
    [{e1, f1} | sorted]
  else
    [first | insert(e1, f1, rest)]
  end
end

## SKapar huffman träd där två löv grupperas och i slutet totala trädet
def huffman([{tree, _}]) do tree end
def huffman([{c1, f1}, {c2, f2} | tail]) do
  huffman(insert({c1, c2}, f1+f2, tail))
end



def huffman_med_enum([{char, _} | []]) do char end
def huffman_med_enum([{c1, f1} | [{c2, f2} | tail]]) do
  huffman(insert_med_enum({{c1, c2}, f1+f2}, tail))
end

def insert_med_enum({c, f}, []) do [{c, f}] end
def insert_med_enum({c1, f1}, [{c2, f2} | tail]) when f1 < f2 do
  [{c1, f1}, {c2, f2} | tail]
end
def insert_med_enum({c1, f1}, [{c2, f2} | tail]) do
  [{c2, f2} | insert_med_enum({c1, f1}, tail)]
end




## Skapar binär väg 0 för vänster och 1 för höger
def encode_table(tree) do
    encode_table(tree, [])
end
def encode_table({left, right}, visit) do
    encode_table(left, [0 | visit]) ++ encode_table(right, [1 | visit])
end
def encode_table(char, visit) do
    [{char, reverse(visit)}]
end

def reverse(l) do
reverse(l, [])
end
def reverse([], r) do r end
def reverse([h | t], r) do
reverse(t, [h | r])
end

def encode([], _) do [] end
def encode([char | rest], table) do
  code = lookup_code(char, table)
  code ++ encode(rest, table)
end

def lookup_code(char, [{char, code} | _]) do code end
def lookup_code(char, [_ | rest]) do
  lookup_code(char, rest)
end
## emergency lookup
def lookup_code(_char, []) do
IO.write("Not encoded: #{_char}\n")
[]
end

## Jämför mattchning av char
def lookup_char(_, []) do :nil end
def lookup_char(code, [{char, code} | _]) do {char, code} end
def lookup_char(code, [_ | rest]) do
   lookup_char(code, rest)
end



def decode_table(tree) do
  encode_table(tree)
end

## Skickar in seq som är kodad med ett table för varje char. Kallar på decode_char för att få rätt char som placeras i en lista
def decode([], _) do [] end
def decode(seq, table) do
  {char, rest} = decode_char(seq, 1, table)
  [char | decode(rest, table)]
end

## Adderar en bit av seq tills den hittar matchande char och jämför med lookup table
def decode_char(seq, n, table) do
  {code, rest} = split(seq, n)
  case lookup_char(code, table) do
    {char, _} -> {char, rest}
    nil -> decode_char(seq, n+1, table)
  end
end

## Splitta upp seq och adderar en bit för att sedan jämföra
def split([], _) do {[], []} end
def split(rest, 0) do {[], rest} end
def split([h | t], n) do
  {first, rest} = split(t, n-1)
  {[h | first], rest}
end

########## Improve encoding/decoding

def better_encode_table(tree) do
  table = encode_table(tree)
  sorted = List.keysort(table, 0) ## sorterar från 0
  filled = fill(sorted, 0) ## fyller på från index 0 med antingen :na eller motsvarande key
  List.to_tuple(filled)
end

def fill([], _) do [] end
def fill([{n, code} | codes], n) do
  [code | fill(codes, n+1)]
end
def fill(codes, n) do
  [:na | fill(codes, n+1)]
end

def better_encode([], _) do [] end
def better_encode([char | rest], table) do
  code = elem(table, char)
  code ++ better_encode(rest, table)
end

def better_decode_table(tree) do tree end

def better_decode([], _) do [] end
def better_decode(seq, tree) do
{char, rest} = better_lookup(seq, tree)
[char | better_decode(rest, tree)]
end

def better_lookup([0 | seq], {left, _}) do
  better_lookup(seq, left)
end
def better_lookup([1 | seq], {_, right}) do
  better_lookup(seq, right)
end
def better_lookup(rest, char) do
  {char, rest}
end

end
