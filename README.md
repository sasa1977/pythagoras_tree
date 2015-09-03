A simple L-system generator for the Pythagoras tree. See [here](http://en.wikipedia.org/wiki/L-system#Example_2:_Pythagoras_Tree) for description.

Usage (Erlang must be built with wxWidgets):

```
$ mix deps.get
$ iex -S mix

# Level 5 tree
iex(1)> PythagorasTree.generate(5)
```

If you need to control window size and pos:

```
iex(1)> PythagorasTree.generate(5, pos: {50, 50}, size: 500)
```