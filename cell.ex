defmodule Cell do



    # Peterson's algorithm
  def lock(id, m, p, q) do
    set(m, true)
    other = rem(id + 1, 2)
    set(q, other)

    case get(p) do
      false ->
        :locked

      true ->
        case get(q) do
          ^id ->
            :locked

          ^other ->
            lock(id, m, p, q)
        end
      end
    end

    def unlock(_id, m, _p, _q) do
      set(m, false)
    end


  def test(n) do
    flag1 = cell(false)
    flag2 = cell(false) # flaggor sätts till false först
    critical = cell(0) #räknas upp
    arbr = cell(0) # ska toggle mellan 0 och 1
    spawn(fn() -> pettr(0, n, critical, flag1, flag2, arbr) end)
    spawn(fn() -> pettr(1, n, critical, flag1, flag2, arbr) end)
    critical
  end


  def pettr(_id, 0, _critical, _m ,_p, _q) do :ok end
  def pettr(id, n, critical, m, p, q) do
    case lock(id, m, p, q) do
      :locked ->
        val = get(critical)
        set(critical, val+1)
        unlock(id, m, p, q)
        pettr(id, n-1, critical, m, p, q)
    end
  end


  def cell(val) do
    spawn(fn -> val(val) end)
  end

  def val(v) do
    receive do
      {:set, val} ->
        val(val)
      {:get, from} ->
        send(from, {:ok, v})
        val(v)
      :stop ->
        :ok
  end
end

  def set(cell, val) do
    send(cell, {:set, val})
  end

  def get(cell) do
    send(cell, {:get, self()})
    receive do
      {:ok, val} -> val
    end
  end





end
