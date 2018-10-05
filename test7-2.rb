class Hoge
  def print2(arg)
    p(arg)
  end
  def print3(arg)
    p(arg + 100)
  end
end
class Foo
  def print2(arg)
    p(2 * arg)
  end
end

hoge = Hoge.new
hoge.print2(2)
hoge.print3(2)
foo = Foo.new
foo.print2(2)