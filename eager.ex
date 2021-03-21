defmodule Eager do

@type atm :: {:atm, atom}
@type variable :: {:var, atom}
@type ignore :: :ignore

@type lambda :: {:lambda, [atom], [atom], seq}

@type cons(t) :: {:cons, t, t}
@type expr :: atm | variable | lambda | call | case | cons(expr)

@type pattern :: atm | variable | ignore | cons(pattern)

@type match :: {:match, pattern, expr}
@type seq :: [expr] | [match | seq]

@type call :: {:call, atom(), [expr]}
@type clause :: {:clause, pattern, seq}
@type case :: {:case, expr, [clause]}

@type closure :: {:closure, [atom], seq, env}
@type str :: atom | [str] | closure

@type env :: [{atom, str}]


  ### eval_expr ger motsvarande datastruktur till ett expression
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} -> {:ok, str}
    end
  end

  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error -> :error
      {:ok, h} -> case eval_expr(tail, env) do
          :error -> :error
          {:ok, ts} -> {:ok, {h, ts}}
        end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, str} ->
        eval_cls(cls, expr, env)
      end
  end



  ## eval_match(patter, str, env) -> ny env lr fail beroende på pattern
  def eval_match({:atm, id}, id, env) do {:ok, env} end

  def eval_match(:ignore, _, env) do
  {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, hp, tp}, {str, ts}, env) do
    case eval_match(hp, str, env) do
      :fail -> :fail
      {:ok, env1} -> eval_match(tp, ts, env1)
    end
  end

  def eval_match(_, _, _) do :fail end


  ## eval_seq kollar en sekvens och kollar först pattern och tar bort bindningar i env 
  def eval_seq([exp], env) do
  eval_expr(exp, env)
  end

  def eval_seq([{:match, patt, expr} | rest], env) do
  case eval_expr(expr, env) do
    :error -> :error
    {:ok, str} ->
      vars = extract_vars(patt)
      env = Env.remove(vars, env)

      case eval_match(patt, str, env) do
        :fail -> :error
        {:ok, env} -> eval_seq(rest, env)
      end
  end
  end


  def extract_vars(binding) do
    extract_vars(binding, [])
  end
  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do
    [var | vars]
  end
  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end


  def eval(seq) do eval_seq(seq, []) end

























end
