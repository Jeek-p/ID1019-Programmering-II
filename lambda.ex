defmodule Lambda do

<sequence> ::= <expression>
                <match> ';' <sequence>

<match> ::= <pattern> '=' <expression>

<expression> ::= <atom>
                 <variable>
                 '{' <expression> ',' <expression> '}'

<pattern> ::= <atom>
              <variable>
              '_'
              '{' <pattern> ',' <pattern> '}'


  ## In the description of the evaluation we will need an environment. This is a mapping from variables in expressions to elements in the domain {x/a,y/b}


  <expression> ::=  <case expression> | ...

  <case expression> ::= 'case' <expression> 'do' <clauses>  'end'

  <clauses> ::=   <clause> | <clause> ';' <clauses>

  <clause> ::=  <pattern> '-\textgreater' <sequence>

  <function> ::= 'fn' '(' <paramters> ')' '->  'end'
  <parameters> ::= ' ' | <variables> '
  <variables> ::= <variable>  |  <variab le> ',' <variables>

  〈expression〉::=〈expression〉’.(’〈arguments〉’)|. . .
  〈arguments〉::=  ’ ’| 〈expressions〉
  〈expressions〉::=〈expression〉 | 〈expression〉’,’〈expressions


  x = _foo; y = :nil; {z, _} = {:bar, :grk}; {x, {z, y}}    ----> {x/foo, y/nil, z/bar}  ---> {foo, {bar, nil}}









end
