# a translation of mr.shiffman's code that instead prints in the terminal

const
  amount = 1_000
  width = 30

proc main = 
  var
    sandpile: array[width, array[width, int]]
    finished = false
  sandpile[width div 2][width div 2] = amount
  
  proc topple = 
    var nextpile: array[width, array[width, int]]
    finished = true
    for i in 0 ..< width:
      for j in 0 ..< width:
        if sandpile[i][j] < 4:
          nextpile[i][j] = sandpile[i][j]
   
    for i in 0 ..< width:
      for j in 0 ..< width:
        if sandpile[i][j] >= 4:
          finished = false
          nextpile[i][j] += sandpile[i][j] - 4
          if i < width - 1:
            inc nextpile[i+1][j]
          if i > 0:
            inc nextpile[i-1][j]
          if j < width - 1:
            inc nextpile[i][j+1]
          if j > 0:
            inc nextpile[i][j-1]
    
    sandpile = nextpile
  
  proc prettyPrint = 
    for i in sandpile:
      for j in i:
        stdout.write (
          case j
          of 0: " "
          of 1: "."
          of 2: ":"
          of 3: "+"
          else: "#"
          ), " "
      stdout.write "|\n" # the pipe is to mark the edge
    stdout.write "\n" # to separate sandpiles
  
  var ix = 0
  while not finished:
    if ix mod 1_000 == 0:
      prettyPrint()
    topple()
    inc ix
  prettyPrint()

main()
