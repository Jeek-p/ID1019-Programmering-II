defmodule Test do

    def main do
       name = IO.gets("Whats your name? ") |> String.trim
       IO.puts "Hello #{name}"

    end

    def double(n) do
      2*n
    end

    def converts(f) do
      ((f-32)/1.8)
    end

    def area_rec(l,s) do
      l*s
    end

    def area_square(l,s) do
      (Test.area_rec(l,s) / s) * l
    end

    def area_circle(r) do
      :math.pi*:math.sqrt(r)
    end

    def data_stuff do
      str = "My sentence"
      IO.puts "Length is : #{String.length(str)}"
      longer = str <> " " <> "is longer"
      IO.puts "Length of longer is : #{String.length(longer)}"
      IO.puts "My ? #{String.contains?(str, "My")}"
      IO.puts "First : #{String.first(str)}"
      IO.puts "Index 4 : #{String.at(str, 4)}"
      IO.puts "Substring : #{String.slice(str, 3, 8)}"

      IO.inspect String.split(longer, " ")

      IO.puts String.reverse(longer)
      IO.puts String.upcase(longer)
      IO.puts String.downcase(longer)

      4*10 |> IO.puts
      age = 20
      IO.puts " and test : #{age > 10 and age > 18}"

      IO.puts " conditions : #{if age > 10, do: "Can do", else: "Cant"}"

    end

    def do_tuple do
      my_stats = {17, 5.23, :Jens}
      IO.puts "Tuyple #{is_tuple(my_stats)}"

      my_stats2 = Tuple.append(my_stats, 30)
      IO.puts "Age #{elem(my_stats2, 3)}" #elem plockar ut specifikt index
      IO.puts "Size #{tuple_size(my_stats2)}"

      my_stats3 = Tuple.delete_at(my_stats2, 0)
      my_stats4 = Tuple.insert_at(my_stats3, 0, 1990)

      many_zero = Tuple.duplicate(0, 5) #skapart en tuple med 5st 0

    end

    def do_list do

      list1 = [1,2,3]
      list2 = [4,5,6]

      list3 = list1 ++ list2

      [head | tail] = list3

      IO.puts "Head : #{head}"
      IO.inspect tail

      Enum.each tail, fn item ->
        IO.puts item
      end


    end




    #### Föreläsning om maps och type strukt


    ## först bara tuple

    def a1() do
      {:car, "Volvo",
        {:model, "XC60", 2018},
        {:color, "blue"},
        {:engine, "A4", 4, 2000, 140},
        {:perf, 4.6, 8.8}}
    end

    def car_brand_model_1 ({:car, brand, {:model, model, _}, _, _, _}) do ## Blir jobbigt om vi ska lägga till properties till car i a1 mååste ändra även denna funktion
      "#{brand} #{model}"


      ## Använder en prop list som vi sedan kan köra list funktioner
      def a2() do
        {:car, "VW",
          [{:model, "Typ-1"},
          {:year, "1964"},
          {:engine, "1300"},
          {:fuel, 4.6},
          {:acc, 12.8}]}
      end

      def car_brand_model_2( {:car, brand, prop}) do ## Med hjälp av en lista av properties i a2 så med keyfind kan vi hitta det vi söker i listan bara och addera vad som helst till den
        case List.keyfind(prop, :model, 0) do
          nil -> brand
          {:model, model} -> "#{brand} #{model}"
        end
      end



      ## använder maps
      def a3() do           ## med mapping så binds key value pair och struktueras i någon form av lista/träd med log(n)
        {:car, "Volvo",
          %{:model => "Typ-1",
            :year => "1964",
            :engine => "1300",
            :cyl => 4,
            :vol => 1300,
            :power => 40,
            :fuel => 4.7,
            :acc => 12.9}}
      end

      def car_brand_model_3( {:car, brand, prop}) do ## Med hjälp av en lista av properties i a2 så med keyfind kan vi hitta det vi söker i listan bara och addera vad som helst till den
        case prop do
          %{:model => model} -> "#{brand} #{model}"
          _ -> brand
        end
      end


      ## struktueras egen strukt
      defstruct brand: "", year: :na, model: "unknown", cyl: :na, power: :na     ## definerar bas fallet för structures

      def a4() do
        %Car{:brand => "SAAB", :model => "96 V4", :year => 1974, :power => 65, :cyl => 4}
      end

      def car_brand_model_4(%Car{brand: brand, model: model}) do   ## kmr lyckas om det är en car struct
        "#{brand} #{model}"
      end

      def year(car = %Car{}) do
        car.year
      end
























end
