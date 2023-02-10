//
//  GameFieldView.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

final class GameFieldView: UIView, CellTappedProtocol, setNumbersProtocol {
    private let collectionViewSquares: UICollectionView
    private var selectedItems: [IndexPath: IndexPath]?
    private var fieldMatrix: [[Int]]
    private let answerMatrix: [[Int]]
    private let solver: SudokuSolver
    public var delegate: SelectionProtocol?
    
    init(levelGame: String) {
        self.collectionViewSquares = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        answerMatrix = GeneratorOfMatrix.getAnswerMatrix()
        fieldMatrix = GeneratorOfMatrix.getMatrix(level: levelGame)
        solver = SudokuSolver(matrix: fieldMatrix)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func countDigitInMatrix() -> [Int] {
        var digits: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        for i in 0..<9 {
            for j in 0..<9 {
                if fieldMatrix[i][j] != 0 {
                    digits[fieldMatrix[i][j] - 1] += 1
                }
            }
        }
        return digits
    }
    
    internal func setFieldMatrix(gameSquare: GameFieldCell, row: Int, col: Int, num: Int) {
        fieldMatrix[row][col] = num
        solver.setMatrix(matrix: fieldMatrix)
        let cellWithNumb = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: row % 3)) as! cellWithNumber
        let beforeNumber = Int(cellWithNumb.getNumber()) ?? 0
        cellWithNumb.setNumberLabel(numb: num)
        refreshFromSelection()
        if (num == 0 || solver.isValidPlaceForNum(row: row, col: col, num: num)) {
            cellWithNumb.setIsCorrectNumb(true)
            refreshFromIncorrectSelection(gameSquare, row, col, beforeNumber)
        } else {
            highlightIncorrectNumber(gameSquare, row, col, num)
        }
        
        if (!isEqualWithAnswerMatrix()) {
            highlightIncorrectNumber(gameSquare, row, col, num)
        }
        tappedAtCell(fieldCellSelected: gameSquare, indexPathSelected: IndexPath(row: col % 3, section: row % 3))
    }
    
    internal func setNumber(collectionView: UICollectionView, cell: cellWithNumber, indexPathWithNumb: IndexPath, cellInField: GameFieldCell) {
        let indCellInField = collectionViewSquares.indexPath(for: cellInField)
        cell.configureNumber(numb:
                                fieldMatrix[(indCellInField?.section ?? 0) * 3 + indexPathWithNumb.section][(indCellInField?.row ?? 0) * 3 + indexPathWithNumb.row]
        )
    }
    
    internal func tappedAtCell(fieldCellSelected: GameFieldCell, indexPathSelected indexPath: IndexPath) {
        refreshFromSelection()
        var selectedNumber = ""
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldCell
            if (sq == fieldCellSelected){
                for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                    if (sq?.collectionViewCells.cellForItem(at: indexPath) == cell) {
                        delegate?.setRowAndColumnOfSelection(fieldCellSelected, collectionViewSquares.indexPath(for: sq!)!.section * 3 + indexPath.section, collectionViewSquares.indexPath(for: sq!)!.row * 3 + indexPath.row, (cell as! cellWithNumber).getPreFilled())
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
                        }
                        selectedNumber = (cell as? cellWithNumber)?.getNumber() ?? "0"
                    } else {
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.2)
                        }
                    }
                }
            } else {
                let currIndex = collectionViewSquares.indexPath(for: sq ?? GameFieldCell())
                let selectedIndex = collectionViewSquares.indexPath(for: fieldCellSelected)
                if currIndex !=  selectedIndex && currIndex?.row == selectedIndex?.row {
                    for k in 0..<3 {
                        let cell = sq?.collectionViewCells.cellForItem(at: IndexPath(row: indexPath.row, section: k))
                        if ((cell as? cellWithNumber)!.isCorrectNumber()){
                            cell?.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.2)
                        }
                    }
                }
                if (currIndex != selectedIndex && currIndex?.section == selectedIndex?.section) {
                    for k in 0..<3 {
                        let cell = sq?.collectionViewCells.cellForItem(at: IndexPath(row: k, section: indexPath.section))
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell?.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.2)
                        }
                    }
                }
            }
        }
        if (selectedNumber != "0" && selectedNumber != "") {
            highlightSameNumbers(selectedNumber: selectedNumber)
        }
    }
    
    internal func refreshFromSelection() {
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldCell
            for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                if ((cell as! cellWithNumber).isCorrectNumber()){
                    cell.backgroundColor = .white
                    if (!(cell as! cellWithNumber).getPreFilled()) {
                        (cell as! cellWithNumber).setColorText(color: SettingsModel.getMainColor())
                    }
                }
            }
        }
    }
    
    internal func refreshFromIncorrectSelection(_ gameSquare: GameFieldCell, _ row: Int, _ col: Int, _ num: Int) {
        let indexSquare = collectionViewSquares.indexPath(for: gameSquare)
        if (solver.isNumOkInCol(row, col, num)) {
            for i in 0..<3 {
                let square = collectionViewSquares.cellForItem(at: IndexPath(row: indexSquare!.row, section: i)) as! GameFieldCell
                for j in 0..<3 {
                    let cellWithNumber = square.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: j)) as! cellWithNumber
                    if (cellWithNumber.getNumber() == String(num)) {
                        cellWithNumber.backgroundColor = .white
                        cellWithNumber.setIsCorrectNumb(true)
                    }
                }
            }
        }
        if (solver.isNumOkInRow(row, col, num)) {
            for i in 0..<3 {
                let square = collectionViewSquares.cellForItem(at: IndexPath(row: i, section: indexSquare!.section)) as! GameFieldCell
                for j in 0..<3 {
                    let cellWithNumber = square.collectionViewCells.cellForItem(at: IndexPath(row: j, section: row % 3)) as! cellWithNumber
                    if (cellWithNumber.getNumber() == String(num)) {
                        cellWithNumber.backgroundColor = .white
                        cellWithNumber.setIsCorrectNumb(true)
                    }
                }
            }
        }
        if (solver.isNumOkInSquare(row, col, row - row % 3, col - col % 3, num)) {
            for cell in gameSquare.collectionViewCells.visibleCells {
                if ((cell as! cellWithNumber).getNumber() == String(num)) {
                    cell.backgroundColor = .white
                    (cell as! cellWithNumber).setIsCorrectNumb(true)
                }
            }
        }
    }
    
    private func isEqualWithAnswerMatrix() -> Bool {
        for i in 0..<9 {
            for j in 0..<9 {
                if (fieldMatrix[i][j] != 0 && fieldMatrix[i][j] != answerMatrix[i][j]) {
                    return false
                }
            }
        }
        return true
    }
    
    private func setupView() {
        layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 1
        backgroundColor = .systemGray
        collectionViewSquares.delegate = self
        collectionViewSquares.dataSource = self
        collectionViewSquares.isScrollEnabled = false
        collectionViewSquares.register(GameFieldCell.self, forCellWithReuseIdentifier: GameFieldCell.reuseIdentifier)
        addSubview(collectionViewSquares)
        collectionViewSquares.pin(to: self, [.top, .bottom, .left, .right])
    }
    
    private func highlightSameNumbers(selectedNumber: String) {
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldCell
            for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                guard let cellWithNumber = cell as? cellWithNumber else {continue}
                if (cellWithNumber.getNumber() == selectedNumber) {
                    if (cellWithNumber.isCorrectNumber()){
                        cellWithNumber.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
                    }
                }
            }
        }
    }
    
    private func highlightIncorrectNumber(_ gameSquare: GameFieldCell, _ row: Int, _ col: Int, _ num: Int) {
        let indexSquare = collectionViewSquares.indexPath(for: gameSquare)
        if (solver.isNumOkInCol(row, col, num)) {
            for i in 0..<3 {
                let square = collectionViewSquares.cellForItem(at: IndexPath(row: indexSquare!.row, section: i)) as! GameFieldCell
                for j in 0..<3 {
                    let cellWithNumber = square.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: j)) as! cellWithNumber
                    if (cellWithNumber.getNumber() == String(num)) {
                        cellWithNumber.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.4)
                        cellWithNumber.setIsCorrectNumb(false)
                    }
                }
            }
        }
        if (solver.isNumOkInRow(row, col, num)) {
            for i in 0..<3 {
                let square = collectionViewSquares.cellForItem(at: IndexPath(row: i, section: indexSquare!.section)) as! GameFieldCell
                for j in 0..<3 {
                    let cellWithNumber = square.collectionViewCells.cellForItem(at: IndexPath(row: j, section: row % 3)) as! cellWithNumber
                    if (cellWithNumber.getNumber() == String(num)) {
                        cellWithNumber.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.4)
                        cellWithNumber.setIsCorrectNumb(false)
                    }
                }
            }
        }
        if (solver.isNumOkInSquare(row, col, row - row % 3, col - col % 3, num)) {
            for cell in gameSquare.collectionViewCells.visibleCells {
                if ((cell as! cellWithNumber).getNumber() == String(num)) {
                    cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.4)
                    (cell as! cellWithNumber).setIsCorrectNumb(false)
                }
            }
        }
        if (!isEqualWithAnswerMatrix()) {
            let cellWithNumber = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: row % 3)) as! cellWithNumber
            cellWithNumber.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.4)
            cellWithNumber.setIsCorrectNumb(false)
        }
    }
}



extension GameFieldView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // dequeue the standard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameFieldCell.reuseIdentifier, for: indexPath)
        (cell as! GameFieldCell).delegateTap = self
        (cell as! GameFieldCell).delegateSetNumber = self
        return cell
    }
    
    
    
}

extension GameFieldView: UICollectionViewDelegate {
}

extension GameFieldView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.frame.width / 3, height: self.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

