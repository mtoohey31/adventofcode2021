let input_lines = readfile("../input")
let input = []
let i = 0
while i < len(input_lines)
  let parts = split(input_lines[i])
  let action = parts[0]
  let step_so_far = [action == "on"]
  let dimensions = split(parts[1], ",")
  let x = 0
  let components = []
  while x < len(dimensions)
    let without_label = dimensions[x][2:]
    let start_and_end = split(without_label, '\.\.')
    let start = str2nr(start_and_end[0]) + 50
    if start > 100
      let x = len(dimensions) + 1
      continue
    elseif start < 0
      let start = 0
    endif
    let end = str2nr(start_and_end[1]) + 50
    if end > 100
      let end = 100
    elseif end < 0
      let x = len(dimensions) + 1
      continue
    endif
    call add(components, [start, end])
    let x += 1
  endwhile
  if x == len(dimensions) + 1
    let i += 1
    continue
  endif
  call add(step_so_far, components)
  call add(input, step_so_far)
  let i += 1
endwhile

let grid = repeat([0], 101)

let x = 0
while x < 101
  let grid[x] = repeat([0], 101)

  let y = 0
  while y < 101
    let grid[x][y] = repeat([0], 101)
    let y += 1
  endwhile
  let x += 1
endwhile

let i = 0
while i < len(input)
  let step = input[i]
  let new_val = step[0]
  let coords = step[1]
  let x = coords[0][0]
  while x <= coords[0][1]
    let y = coords[1][0]
    while y <= coords[1][1]
      let z = coords[2][0]
      while z <= coords[2][1]
        let grid[x][y][z] = new_val
        let z += 1
      endwhile
      let y += 1
    endwhile
    let x += 1
  endwhile
  let i += 1
endwhile

let sum_so_far = 0

let x = 0
while x < len(grid)
  let y = 0
  while y < len(grid[x])
    let z = 0
    while z < len(grid[x][y])
      let sum_so_far = sum_so_far + grid[x][y][z]
      let z += 1
    endwhile
    let y += 1
  endwhile
  let x += 1
endwhile

echo sum_so_far
