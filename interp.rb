require "minruby"

# An implementation of the evaluator
def evaluate(exp, env)
  # exp: A current node of AST
  # env: An environment (explained later)

  case exp[0]

#
## Problem 1: Arithmetics
#

  when "lit"
    exp[1] # return the immediate value as is

  when "+"
    evaluate(exp[1], env) + evaluate(exp[2], env)
  when "-"
    evaluate(exp[1], env) - evaluate(exp[2], env)
  when "*"
    evaluate(exp[1], env) * evaluate(exp[2], env)
  when "%"
    evaluate(exp[1], env) % evaluate(exp[2], env)
  when "/"
    evaluate(exp[1], env) / evaluate(exp[2], env)

  
#
## Problem 2: Statements and variables
#

  when "stmts"
    exp[1..-1].each do |e|
      evaluate(e, env)
    end
  when "var_ref"
    env[exp[1]]
  when "var_assign"
    env[exp[1]] = evaluate(exp[2], env)

#
## Problem 3: Branchs and loops
#
  when ">"
    evaluate(exp[1], env) > evaluate(exp[2], env)
  when "<"
    evaluate(exp[1], env) < evaluate(exp[2], env)
  when "=="
    evaluate(exp[1], env) == evaluate(exp[2], env)


  when "if"
    if evaluate(exp[1], env)
      evaluate(exp[2], env)
    else
      evaluate(exp[3], env)
    end

  when "while"
    while evaluate(exp[1], env)
      evaluate(exp[2], env)
    end

#
## Problem 4: Function calls
#

  when "func_call"
    # Lookup the function definition by the given function name.
    func = $function_definitions[exp[1]]

    if func.nil?
      # We couldn't find a user-defined function definition;
      # it should be a builtin function.
      # Dispatch upon the given function name, and do paticular tasks.
      case exp[1]
      when "p"
        # MinRuby's `p` method is implemented by Ruby's `p` method.
        p(evaluate(exp[2], env))
      # ... Problem 4
      when "Integer"
        Integer(evaluate(exp[2], env))
      when "fizzbuzz"
        num = evaluate(exp[2], env)
        result = ""
        if num % 3 == 0
          result += "Fizz"
        end
        if num % 5 == 0
          result += "Buzz"
        end
        result.empty? ? num : result
      else
        raise("unknown builtin function")
      end
    else


#
## Problem 5: Function definition
#

      # (You may want to implement "func_def" first.)
      #
      # Here, we could find a user-defined function definition.
      # The variable `func` should be a value that was stored at "func_def":
      # parameter list and AST of function body.
      #
      # Function calls evaluates the AST of function body within a new scope.
      # You know, you cannot access a varible out of function.
      # Therefore, you need to create a new environment, and evaluate the
      # function body under the environment.
      #
      # Note, you can access formal parameters (*1) in function body.
      # So, the new environment must be initialized with each parameter.
      #
      # (*1) formal parameter: a variable as found in the function definition.
      # For example, `a`, `b`, and `c` are the formal parameters of
      # `def foo(a, b, c)`.
      raise(NotImplementedError) # Problem 5
    end

  when "func_def"
    # Function definition.
    #
    # Add a new function definition to function definition list.
    # The AST of "func_def" contains function name, parameter list, and the
    # child AST of function body.
    # All you need is store them into $function_definitions.
    #
    # Advice: $function_definitions[???] = ???
    raise(NotImplementedError) # Problem 5


#
## Problem 6: Arrays and Hashes
#

  # You don't need advices anymore, do you?
  when "ary_new"
    raise(NotImplementedError) # Problem 6

  when "ary_ref"
    raise(NotImplementedError) # Problem 6

  when "ary_assign"
    raise(NotImplementedError) # Problem 6

  when "hash_new"
    raise(NotImplementedError) # Problem 6

  else
    p("error")
    pp(exp)
    raise("unknown node")
  end
end


$function_definitions = {}
env = {}

# `minruby_load()` == `File.read(ARGV.shift)`
# `minruby_parse(str)` parses a program text given, and returns its AST
evaluate(minruby_parse(minruby_load()), env)
