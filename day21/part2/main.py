from functools import reduce
import re

memo = {}

def tuple_sum(t: list[tuple[int, int]]) -> tuple[int, int]:
    return reduce(lambda a, b: (a[0] + b[0], a[1] + b[1]), t)

def f(pcs:int, pcp: int, pps: int, ppp: int, r: int, rs: int) -> tuple[int,
    int]:
    at = (pcs, pcp, pps, ppp, r, rs)
    if at in memo:
        return memo[at]
    if r <= 2:
        memo[at] = tuple_sum([f(pcs, pcp, pps, ppp, r + 1, rs + n) for n in range(1, 4)])
        return memo[at]
    pcp = (pcp + rs) % 10 or 10
    pcs += pcp
    if pcs >= 21:
        memo[at] = (1, 0)
        return memo[at]
    res = f(pps, ppp, pcs, pcp, 0, 0)
    memo[at] = (res[1], res[0])
    return memo[at]

input_lines = [line.strip() for line in open("../input", "r").readlines()]
pos_re = re.compile(r'\d+$')
p1p = int(pos_re.search(input_lines[0]).group(0)) # type: ignore
p2p = int(pos_re.search(input_lines[1]).group(0)) # type: ignore
print(f(0, p1p, 0, p2p, 0, 0))
