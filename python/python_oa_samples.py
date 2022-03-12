# wayfair:

# write a function "solution": given two integers A and B,
# returns the number of integers from the range [A..B] (ends are included)
# which can be expressed as the product of two consecutive integers
# that is X*(X+1), for some integer X.
# Assumptions: A and B are integers within the range [1...1,000,000,000];
# A <= B

#####################
# from math import sqrt


def solution(A, B):
    """
    x*(x+1) = a is even.
    sqrt(4a+1) is an int.
    """
    # find the even sublist from the original list
    ls_even = [x for x in range(A, B + 1) if x % 2 == 0]

    # check sqrt(4a+1) is an int
    result = []
    for i in ls_even:
        temp = sqrt(4 * i + 1)
        if temp == round(temp):
            result.append(i)

    if len(result) == 0:
        result = 0
    return result


print(solution(6, 20))
print(solution(21, 29))


# Given an array A of integers containing N integers
# sum all the two-digit numbers in the array
# Assumptions: N >=0; can be negative numbers

#####################
def solution(A):
    result = 0
    for i in A:
        if abs(i) > 9 and abs(i) < 100:
            result += i

    return result


print(solution([1, 1000, 80, -91]))
print(solution([47, 1900, 1, 90, 45]))
print(solution([-13, 1900, 1, 100, 45]))


# Given an integer N, returns the smallest integer that is
# greater than N and the sum of whose digits is equal to
# the sum of the digits of N.

# def solution(N):
#     sum_digits =
