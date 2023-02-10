//
//  SudokuSolver.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/9/23.
//
// MARK: - Sudoku solver
/// Sudoku solver for checking filled numbers on correct.
/// Can also solve sudoku
class SudokuSolver {
    
    /// matrix that needed to be solve
    private var matrix: [[Int]]
    /// random positino for random acces of matrix
    private var randPos = getRandPos()
    /// random numbers from 1 to 9
    private var randNumb = getRandNumb()
    
    // MARK: - init()
    init(matrix: [[Int]]) {
        self.matrix = matrix
    }
    
    /// Get the random positions. Filled array from 0 to 81 and then shuffle this array
    private static func getRandPos() -> [Int] {
        var pos: [Int] = []
        for i in 0..<81 {
            pos.append(i)
        }
        pos.shuffle()
        return pos
    }
    
    /// Get random numbers. Filled array from 1 to 9 and then shuffle this array
    private static func getRandNumb() -> [Int] {
        var pos: [Int] = []
        for i in 1...9 {
            pos.append(i)
        }
        pos.shuffle()
        return pos
    }
    
    /// Set matrix that needed to be solved
    public func setMatrix(matrix: [[Int]]) {
        self.matrix = matrix
    }
    
    /// Checking for same number in the column
    public func isNumOkInCol(_ row: Int, _ col: Int, _ num: Int) -> Bool {
        for i in 0..<9 {
            if (matrix[i][col] == num && row != i) {
                return true
            }
        }
        return false
    }
    
    /// Checking for same number in the row
    public func isNumOkInRow(_ row: Int, _ col: Int, _ num: Int) -> Bool {
        for i in 0..<9 {
            if (matrix[row][i] == num && col != i) {
                return true
            }
        }
        return false
    }
    
    /// Checkign for same number in the square
    public func isNumOkInSquare(_ row: Int, _ col: Int, _ squareRow: Int, _ squareCol: Int, _ num: Int) -> Bool {
        for i in 0..<3 {
            for j in 0..<3 {
                if (row != i + squareRow && col != j + squareCol && matrix[i + squareRow][j + squareCol] == num) {
                    return true
                }
            }
        }
        return false
    }
    
    /// Checking is it valid place for number
    public func isValidPlaceForNum(row: Int, col: Int, num: Int) -> Bool {
        !isNumOkInCol(row, col, num) &&
        !isNumOkInRow(row, col, num) &&
        !isNumOkInSquare(row, col, row - row % 3, col - col % 3, num)
    }
    
    /// Checking is number in the column
    private func isNumInCol(col: Int, num: Int) -> Bool {
        for i in 0..<9 {
            if (matrix[i][col] == num) {
                return true
            }
        }
        return false
    }
    
    /// Checking is number in the row
    private func isNumInRow(row: Int, num: Int) -> Bool {
        for i in 0..<9 {
            if (matrix[row][i] == num) {
                return true
            }
        }
        return false
    }
    
    /// Checking is number in the square
    private func isNumInSquare(squareRow: Int, squareCol: Int, num: Int) -> Bool {
        for row in 0..<3 {
            for col in 0..<3 {
                if (matrix[row + squareRow][col + squareCol] == num) {
                    return true
                }
            }
        }
        return false
    }
    
    /// Finding the empty space in the matrix
    private func findEmptyPlace(row: inout Int, col: inout Int) -> Bool {
        for i in 0..<9 {
            for j in 0..<9 {
                if (matrix[i][j] == 0) {
                    row = i
                    col = j
                    return true
                }
            }
        }
        return false
    }
    
    private func isValidPlace(row: Int, col: Int, num: Int) -> Bool {
        !isNumInCol(col: col, num: num) &&
        !isNumInRow(row: row, num: num) &&
        !isNumInSquare(squareRow: row - row % 3, squareCol: col - col % 3, num: num)
    }
    
    public func getSudokuMatrix(_ neededDifficult: Int) -> [[Int]] {
        let solver = SudokuSolver(matrix: matrix)
        var difficult = 81
        for k in 0..<81 {
            let x = randPos[k] / 9, y = randPos[k] % 9
            let temp = matrix[x][y]
            matrix[x][y] = 0
            difficult -= 1
            
            solver.setMatrix(matrix: matrix)
            
            var check = 0
            solver.countSoln(number: &check)
            
            if (check != 1) {
                matrix[x][y] = temp
                difficult += 1
            }
            
            if (difficult <= neededDifficult) {
                print("nice")
                print("difficult: \(difficult), needed: \(neededDifficult)")
                break
            }
        }
        return matrix
    }
    
    private func countSoln(number: inout Int) {
        var row = 0, col = 0
        if (!findEmptyPlace(row: &row, col: &col)) {
            number += 1
            return
        }
        for i in 0..<9 {
            if (number >= 2) {
                break
            }
            if (isValidPlace(row: row, col: col, num: randNumb[i])) {
                matrix[row][col] = randNumb[i];
                
                countSoln(number: &number);
            }
            matrix[row][col] = 0;
        }
    }
    
    public func solveSudoku() -> Bool {
        var row = 0, col = 0
        if (!findEmptyPlace(row: &row, col: &col)) {
            return true
        }
        for num in 1...9 {
            if (isValidPlace(row: row, col: col, num: num)) {
                matrix[row][col] = num
                if (solveSudoku()) {
                    return true
                }
                matrix[row][col] = 0
            }
        }
        return false
    }
}
