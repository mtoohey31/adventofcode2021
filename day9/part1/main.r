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
sum <- 0
for (i in seq_len(nrow(grid))) {
  for (j in seq_len(ncol(grid))) {
    if (check_min(i, j)) {
      sum <- sum + as.integer(grid[i, j]) + 1
    }
  }
}
print(sum)
