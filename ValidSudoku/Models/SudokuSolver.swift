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
    public var matrix: [[Int]]
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
        print("difficult: \(difficult), needed: \(neededDifficult)")
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
    
    private func checkOnlyPlaceForNumInCol(_ arr: [Int], _ num: Int, _ col: Int) -> (row: Int, col: Int) {
        var line = arr
        for i in 0...8 {
            if (line[i] == 0 && !isValidPlace(row: i, col: col, num: num)) {
                line[i] = -1
            }
        }
        var count = 0
        var coords_to_return = (-1, -1)
        for i in 0...8 {
            if (line[i] == 0) {
                count += 1
                coords_to_return = (i, col)
            }
         }
        if (count == 1) {
            return coords_to_return
        }
        return (-1, -1)
    }
    
    private func checkOnlyPlaceForNumInRow(_ arr: [Int], _ num: Int, _ row: Int) -> (row: Int, col: Int) {
        var line = arr
        for i in 0...8 {
            if (line[i] == 0 && !isValidPlace(row: row, col: i, num: num)) {
                line[i] = -1
            }
        }
        var count = 0
        var coords_to_return = (-1, -1)
        for i in 0...8 {
            if (line[i] == 0) {
                count += 1
                coords_to_return = (row, i)
            }
        }
        if (count == 1) {
            return coords_to_return
        }
        return (-1, -1)
    }
    
    private func checkOnlyPlaceForNumInSquare(_ sq: [[Int]], _ num: Int, _ area_row: Int, _ area_col: Int) -> (row: Int, col: Int) {
        var square = sq
        for i in 0...2 {
            for j in 0...2 {
                if (square[i][j] == 0 && !isValidPlace(row: area_row * 3 + i, col: area_col * 3 + j, num: num)) {
                    square[i][j] = -1
                }
            }
        }
        
        var count = 0
        var coord_to_return = (-1, -1)
        for i in 0...2 {
            for j in 0...2 {
                if (square[i][j] == 0) {
                    count += 1
                    coord_to_return = (i, j)
                }
            }
        }
        if (count == 1) {
            return coord_to_return
        }
        return (-1, -1)
    }
    
    public func getOneNubmberForSolve(number: inout Int, row: inout Int, col: inout Int) {
        // check for every square
        var square: [[Int]] = [[0, 0, 0],
                               [0, 0, 0],
                               [0, 0, 0]]
        //        0       1       2
        //      . . . | . . . | . . .
        //  0   . . . | . . . | . . .
        //      . . . | . . . | . . .
        //      ---------------------
        //      . . . | . . . | . . .
        //  1   . . . | . . . | . . .
        //      . . . | . . . | . . .
        //      ---------------------
        //      . . . | . . . | . . .
        //  2   . . . | . . . | . . .
        //      . . . | . . . | . . .
        
        for square_i in 0...2 {
            for square_j in 0...2 {
                var nums_in_square = [false, false, false, false, false, false, false, false ,false]
                for i in 0...2 {
                    for j in 0...2 {
                        square[i][j] = matrix[square_i * 3 + i][square_j * 3 + j]
                        if (square[i][j] != 0) {
                            nums_in_square[square[i][j] - 1] = true
                        }
                    }
                }
                for num in 0...8 {
                    if (!nums_in_square[num]) {
                        let coords = checkOnlyPlaceForNumInSquare(square, num + 1, square_i, square_j)
                        if (coords != (-1, -1)) {
                            number = num + 1
                            row = square_i * 3 + coords.row
                            col = square_j * 3 + coords.col
                            return
                        }
                    }
                }

            }
        }
        
        // check in row
        for i in 0...8 {
            var nums_in_row = [false, false, false, false, false, false, false, false ,false]
            let arr = matrix[i]
            for j in 0...8 {
                if (arr[j] != 0) {
                    nums_in_row[arr[j] - 1] = true
                }
            }
            for num in 0...8 {
                if (!nums_in_row[num]) {
                    let coords = checkOnlyPlaceForNumInRow(arr, num + 1, i)
                    print(coords)
                    if (coords != (-1, -1)) {
                        number = num + 1
                        row = i
                        col = coords.col
                        return
                    }
                }
            }
        }
        
        // check in column
        for j in 0...8 {
            var nums_in_col = [false, false, false, false, false, false, false, false, false]
            var arr: [Int] = []
            for i in 0...8 {
                arr.append(matrix[i][j])
                if (matrix[i][j] != 0) {
                    nums_in_col[matrix[i][j] - 1] = true
                }
            }
            for num in 0...8 {
                if (!nums_in_col[num]) {
                    let coords = checkOnlyPlaceForNumInCol(arr, num + 1, j)
                    if (coords != (-1, -1)) {
                        number = num + 1
                        row = coords.row
                        col = j
                        return
                    }
                }
            }
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
