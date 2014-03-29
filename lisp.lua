--[[
  lisp.lua
  Old file got deleted somehow... implementation #2
--]]

util = require "util"
g_env = require "stdlib"

function tokenize (prog)
  local ch
  local token = ""
  local tokens = {}
  local comment = false
  for i=1,#prog do
    ch = string.sub(prog, i, i)
    
    if ch == "\n" and comment then
      comment = false
    end
    
    if not comment then
      if ch == "(" then
        table.insert(tokens, ch)
        token = ""
      elseif ch == ")" then
        if #token > 0 then
          table.insert(tokens, token)
        end
        table.insert(tokens, ch)
        token = ""
      elseif ch == " " or ch == "\n" then
        if #token > 0 then
          table.insert(tokens, token)
        end
        token = ""
      elseif ch == ";" then
        comment = true
      else
        token = token .. ch
      end
    end
  end  
  
  return tokens
end

function atomize(token)
  -- could be done with a val = tonumber(token) or tostring(token),
  -- but not flexible for later token types
  if tonumber(token) == nil then -- NaN
    return tostring(token),type(token)
  else
    return tonumber(token),type(token)
  end
end

function parse (tokens)
  token = table.remove(tokens, 1)
  if #tokens == 0 then
    print ("Unexpected EOF, exiting")
    exit(1)
  elseif token == "(" then
    local subtab = {}
    while not (tokens[1] == ")") do  -- peek at the next token
      table.insert(subtab, parse(tokens))
    end
    table.remove(tokens, 1) -- remove the )
    return subtab
  elseif token == ")" then
    print ("Unexpected \")\", exiting.")
    exit(1)
  else
    local tok,_ = atomize(token)
    return tok -- no string support yet
  end
end

function die (msg)
  print(msg)
  os.exit(1)
end

function runproc(proc, evalfunc, subenv)
  -- env is not the global env, can modify
  -- proc is already parsed ie a list of symbols right
  local arglist = proc[1]
  local prog = proc[2]
  return function (fargs)
    for i=1,#arglist do
      -- table of arglist.sym = fargs.val
      subenv[arglist[i]] = fargs[i]
    end
    
    return evalfunc(prog, subenv)
  end
end

function eval (prog, env)
  -- takes a table, iterates over table,
  -- evals any subtables, feeds results of sub evals to the env procedure
  if env == nil then
    die("didn't pass env to eval!")
  end
  
  if type(prog) == "table" then
    local f
    local fargs = {}
    for k,v in ipairs(prog) do
      if k == 1 then -- the first in a list is a procedure
        if v == "define" then
          local newsymbol = prog[2]
          if type(newsymbol) ~= "string" then
            die("First argument of define not a symbol: " .. newsymbol)
          end
          env[newsymbol] = eval(prog[3],env)
          return env[newsymbol]
        elseif v == "if" then
          if eval(prog[2], env) then
            return eval(prog[3], env)
          else
            return eval(prog[4], env)
          end
        elseif v == "lambda" then
          return {prog[2], prog[3]}
        elseif env[v] == nil then
          die("Undefined: " .. tostring(v))
        else
          -- is a symbol
          if type(env[v]) == "table" then
            f = runproc(env[v] --[[has arglist of tokens, and tokenized body--]], eval, util.copy(env)) -- needs eval function
          else
            f = env[v]
          end
        end
      else
        if type(v) == "table" then
          table.insert(fargs, eval(v, env))
        elseif type(v) == "string" then -- is a symbol.  String will have their own new type
          if env[v] == nil then die("undefined var: " .. v) end
          table.insert(fargs, env[v])
        elseif type(v) == "number" then
          table.insert(fargs, v)
        end
      end
    end
    if f == nil then
      util.tprint(prog)
      die("syntax error or function not defined")
    else
      return f(fargs)
    end
  else
    if type(prog) == "string" then
      return env[prog]
    elseif type(prog) == "number" then
      return prog
    end
  end
end

function run (progstring)
  local tokens = tokenize(progstring)
  local parsed = {}
  local results = {}
  while #tokens > 0 do
    table.insert(parsed, parse(tokens))
  end
  for k,tab in ipairs(parsed) do
    table.insert(results, eval(tab, g_env) or "nil")
  end
  return results
end

p = "(if (and #f #f) (print 1) (print 2))"
p2 = "(define fac (lambda (x) (if (= 0 x) 1 (* x (fac (- x 1)))))) (print (fac 5))"

filetest = io.open("demo.lisp", r)
p3 = filetest:read("*all")
filetest:close()

result = run(p3)
print("-----------------------------------------")
--util.tprint(result)