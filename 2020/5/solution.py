from aoc_utils import aoc_utils
from tests import cases


def bsp(code, arrow, max_range):
    r = [0, max_range]
    for letter in code:
        rlength = (r[1] - r[0] + 1) / 2
        if letter == arrow:
            r[0] += rlength
        else:
            r[1] -= rlength

    return int(r[0])


def answer(problem_input, level, test=False):
    seat_ids = []
    for boarding_pass in problem_input.splitlines():
        row, col = bsp(boarding_pass[:7], 'B', 127), bsp(boarding_pass[7:], 'R', 7)
        seat_ids.append(row * 8 + col)

    max_seat_id, min_seat_id = max(seat_ids),  min(seat_ids)
    return max_seat_id if level == 1 else set(range(min_seat_id, max_seat_id)) - set(seat_ids)


aoc_utils.run(answer, cases)
