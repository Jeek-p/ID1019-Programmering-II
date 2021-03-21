defmodule  Travel do

  ## directed and no cycles : DAG

  def shortest(from, from, _) do
    {0, []}
  end
  def shortest(from, to, graph) do
    next = Graph.next(from, graph)
    distances = distances(next, to, graph)
    select(distances)
  end

  # next är dem vi kan besöka och to är dit vi ska. Next är en lista av noder och beskrivs av fn(n,d) där n är en nod och d är distance
  def distances(next, to, graph) do
    Enum.map(next,
    fn ({n,d}) ->
      case shortest(n, to, graph) do
        {:inf, nil}->
          {:inf, nil}
          {k, path} ->
            {d+k, [n|path]} #hittar vi en väx så adderar vi d med k för att få total kostnad sedan lägger vi till n i path listan
          end
        end)
      end

  #distances är en lista med avstånd och vägar.
  def select(distances) do
    List.foldl(distances,
    {:inf, nil},
    fn ({d,_}=s,{ad,_}=acc) -> # titta på första elementen(d) i listan vad kostar det. acc är sammanlagda kostnaden och gör koll mot d
      if d < ad do
        s
      else
        acc
      end
    end)
  end

  ## DAG with memorization
  
  def dynamic(from, to, graph) do
    mem = Memory.new()
    {solution, _} = shortest(from, to, graph, mem)
    solution
  end

  def check(from, to, graph, mem) do
    case Memory.lookup(from, mem) do
      {_, solution} ->
        {solution, mem}
        nil ->
          {solution, mem} = shortest(from, to, graph, mem)
          {solution,  Memory.store(from, solution, mem)}
        end
      end

      def shortest(from, from, _, mem) do
        {{0, []}, mem};
      end
      def shortest(from, to, graph, mem) do
        next = Graph.next(from, graph)
        {distances, mem} = distances(next, to, graph, mem)
        shortest =  select(distances)
        {shortest, mem}
      end

      def distances(next, to, graph, mem) do
        List.foldl(next, {[], mem},
        fn ({t,d}, {dis,mem}=acc) ->
          case check(t, to, graph, mem) do
            {{:inf, _}, _} ->
              acc
              {{n, path}, mem} ->
                {[{d+n, [t|path]}| dis ], mem}
              end
            end)
          end

        end
