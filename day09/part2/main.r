library(tibble)

input_file <- file("../input", "r")
string_lines <- c()
i <- 1
while (TRUE) {
  line <- readLines(input_file, n = 1)
  if (length(line) == 0) {
    break
  } else {
    string_lines[i] <- line
  }
  i <- i + 1
}
grid <- matrix(
  data = sapply(unlist(strsplit(string_lines, "")), strtoi),
  nrow = nchar(string_lines[1]),
  ncol = length(string_lines)
)
check_min <- function(i, j) {
  if (i < nrow(grid) && j < ncol(grid)) {
    return(as.integer(grid[i, j]) < min(
      grid[i - 1, j], grid[i + 1, j],
      grid[i, j - 1], grid[i, j + 1]
    ))
  } else if (i < nrow(grid)) {
    return(as.integer(grid[i, j]) < min(
      grid[i - 1, j], grid[i + 1, j],
      grid[i, j - 1]
    ))
  } else if (j < ncol(grid)) {
    return(as.integer(grid[i, j]) < min(
      grid[i - 1, j],
      grid[i, j - 1], grid[i, j + 1]
    ))
  } else {
    return(as.integer(grid[i, j]) < min(
      grid[i - 1, j],
      grid[i, j - 1]
    ))
  }
}
low_points <- list()
for (i in seq_len(nrow(grid))) {
  for (j in seq_len(ncol(grid))) {
    if (check_min(i, j)) {
      low_points[length(low_points) + 1] <- list(list(i, j))
    }
  }
}
gn <- function(i, j) {
  as.integer(lapply(low_points[i], "[[", j))
}
get_basin_size_recursive <- function(n) {
  above <- n - nrow(grid)
  left <- n - 1
  right <- n + 1
  below <- n + nrow(grid)
  next_vals <- c(above, below)
  if (n %% nrow(grid) != 1) {
    next_vals[length(next_vals) + 1] <- left
  }
  if (n %% nrow(grid) != 0) {
    next_vals[length(next_vals) + 1] <- right
  }
  filtered_next_vals <- c()
  for (i in seq_len(length(next_vals))) {
    if (next_vals[i] >= 1 && length(grid) >= next_vals[i] &&
      grid[next_vals[i]] != 9 && !(next_vals[i] %in% visited)) {
      filtered_next_vals[length(filtered_next_vals) + 1] <- next_vals[i]
    }
  }
  visited <<- append(visited, filtered_next_vals)
  this_sum <- 1
  for (i in seq_len(length(filtered_next_vals))) {
    this_sum <- this_sum + get_basin_size_recursive(filtered_next_vals[i])
  }
  return(this_sum)
}
sizes <- c()
for (i in seq_len(length(low_points))) {
  n <- gn(i, 1) + (nrow(grid) * (gn(i, 2) - 1))
  visited <<- c(n)
  sizes[i] <- get_basin_size_recursive(n)
}
print(prod(tail(sort(sizes), n = 3)))
