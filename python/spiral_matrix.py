# Spiral Matrix

https://leetcode.com/explore/challenge/card/september-leetcoding-challenge-2021/638/week-3-september-15th-september-21st/3977/

matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]

def spiral_matrix(matrix):
	result = []

	while len(matrix) != 1:
	    result += matrix[0]
	    matrix = matrix[1:]
	    matrix = [[line[-i] for line in matrix] for i in range(1, len(matrix[0])+1)]

	return result += matrix[0]