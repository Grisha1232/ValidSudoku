//
//  GeneratorOfMatrix.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/3/23.
//



class GeneratorOfMatrix {
    
    private static let defaultMatrix: [[Int]] = [[1, 2, 3, 4, 5, 6, 7, 8, 9],
                                                [4, 5, 6, 7, 8, 9, 1, 2, 3],
                                                [7, 8, 9, 1, 2, 3, 4, 5, 6],
                                                [2, 3, 4, 5, 6, 7, 8, 9, 1],
                                                [5, 6, 7, 8, 9, 1, 2, 3, 4],
                                                [8, 9, 1, 2, 3, 4, 5, 6, 7],
                                                [3, 4, 5, 6, 7, 8, 9, 1, 2],
                                                [6, 7, 8, 9, 1, 2, 3, 4, 5],
                                                [9, 1, 2, 3, 4, 5, 6, 7, 8]]
    private static var matrix: [[Int]] = defaultMatrix

    public static func getAnswerMatrix() -> [[Int]] {
        matrix = defaultMatrix
        mixMatrixUp()
        return matrix
    }
    
    public static func getMatrix(level: String) -> [[Int]] {
        let solver = SudokuSolver(matrix: matrix)
        let amountOfHints: Int
        if (level == "Easy") {
            amountOfHints = Int.random(in: 30...35)
        } else if (level == "Medium") {
            amountOfHints = Int.random(in: 25...30)
        } else if (level == "Hard") {
            amountOfHints = Int.random(in: 20...25)
        } else {
            amountOfHints = Int.random(in: 20...25)
        }
        matrix = solver.getSudokuMatrix(amountOfHints)
        return matrix
    }
    
    private static func getZeroMatrix() -> [[Int]] {
        var grid: [[Int]] = []
        for _ in 0..<9 {
            grid.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        }
        return grid
    }
    
    
    private static func mixMatrixUp() {
        let funcs = [swapRows, swapColumns, swapRowsArea, swapColumnsArea, transpose]
        for _ in 0...25 {
            funcs.randomElement()!()
        }
    }
    
    // Swaps rows of the matrix
    private static func swapRows() {
        let area = Int.random(in: 0...2)
        let line1 = Int.random(in: 0..<3)
        let i = area * 3 + line1
        
        var line2 = Int.random(in: 0..<3)
        while (line1 == line2) {
            line2 = Int.random(in: 0..<3)
        }
        let j = area * 3 + line2
        
        for k in 0..<9 {
            let temp = matrix[i][k]
            matrix[i][k] = matrix[j][k]
            matrix[j][k] = temp
        }
    }
    
    // Swaps columns of the matrix
    private static func swapColumns() {
        transpose()
        swapRows()
        transpose()
    }
    
    // Swaps rows areas of the matrix
    private static func swapRowsArea() {
        let i = Int.random(in: 0...2)
        var j = Int.random(in: 0...2)
        while (i == j) {
            j = Int.random(in: 0...2)
        }
        for k in 0...2 {
            let temp = matrix[i * 3 + k]
            matrix[i * 3 + k] = matrix[j * 3 + k]
            matrix[j * 3 + k] = temp
        }
    }
    
    private static func swapColumnsArea() {
        transpose()
        swapRowsArea()
        transpose()
    }
    
    // Transpose the matrix
    private static func transpose() {
        let copy = matrix
        for i in 0..<9 {
            for j in 0..<9 {
                matrix[i][j] = copy[j][i];
            }
        }
    }
    
}
