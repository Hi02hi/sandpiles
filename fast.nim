#[
the main optimizations

reduce the search space for possible cells greater than 4
by adding a radius var and only searching in that square

sidenote: i think reducing the space even more will slow
me down more than it speeds me up

only have 1 array. it messes with the generations,
but returns the same end result. also, its another
speed boost if i dont print until it's stable

take advantage of the fact that there is 4-fold symmetry and
only keep track of 1 quadrant
|0|4|0|
|4|0|4| is stored as |0|4|
|0|4|0|              |4|0|, the lower right quadrant
this leads to some
interesting caveats, for example

this is correct
|0|4|0|      |0|0|1|0|0|     |0|0|1|0|0|
|4|0|4| ->   |0|2|0|2|0|     |0|2|1|2|0|
|0|4|0|      |1|0|4|0|1| ->  |1|1|0|1|1|
             |0|2|0|2|0|     |0|2|1|2|0|
             |0|0|1|0|0|     |0|0|1|0|0|
however, this would happen incorrectly
|0|4|                        |0|0|1|0|0|
|4|0| -> |2|0|1|, printed as |0|2|0|2|0|
         |0|2|0|             |1|0|2|0|1|
         |1|0|0|             |0|2|0|2|0|
                             |0|0|1|0|0|

so i added an extra rule to fix this
if sand topples into the middle row or column
then another cell would topple here b/c symmetry,
so add an extra grain of sand
]#

const
  # known at compile time, so can be used as size for arrays
  dump = 100_000
  width = 117
  wmo = width - 1 # width minus one

proc main = 
  var
    sandpile: array[width, array[width, int]]
    radius = 1
    finished = false
  sandpile[0][0] = dump
  # see why i chose the lower right quadrant now?

  while not finished:
    finished = true
    for i in 0 ..< radius:
      for j in 0 ..< radius:
        if sandpile[i][j] > 3:
          finished = false
          sandpile[i][j] -= 4
          if i < wmo:
            inc sandpile[i+1][j]
          if i > 0:
            inc sandpile[i-1][j]
          if j < wmo:
            inc sandpile[i][j+1]
          if j > 0:
            inc sandpile[i][j-1]
          if i == 1:
            inc sandpile[0][j]
          if j == 1:
            inc sandpile[i][0]
    if sandpile[0][radius] > 3:
      inc radius

  let image = open("image.txt", fmWrite)

  image.write "P3\n" & $(2*wmo + 1) & " " & $(2*wmo + 1) & "\n255\n"

  for i in -wmo .. wmo:
    var row = ""
    for j in -wmo .. wmo:
      row &= (
        case sandpile[abs i][abs j]
        of 0: "255 255 0"
        of 1: "0 185 63"
        of 2: "0 104 255"
        of 3: "122 0 229 "
        else: ">:(" # never supposed to happen
        ) & " "

    image.writeLine row
  
  image.close()

main()
echo "done"
# 0.92 seconds for 100K!
# 30.66 seconds for 500K!
# 128.6 seconds for 1M!
