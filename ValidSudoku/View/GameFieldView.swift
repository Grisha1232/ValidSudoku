//
//  GameFieldView.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

// MARK: - GameFieldView
final class GameFieldView: UIView, CellTappedProtocol, setNumbersProtocol {
    
    
    // MARK: - Variables
    /// Squares fo the field [3 x 3]
    private let collectionViewSquares: UICollectionView
    /// matrix of sudoku that represents on the screen
    private var fieldMatrix: [[Int]]
    /// matrix with note information
    private var fieldNoteMatrix: [[[Bool]?]]
    /// matrix indicated wether it filled by game or by user
    private var preFilled: [[Bool]]
    /// answer matrix for sudoku
    private var answerMatrix: [[Int]]
    /// solver of sudoku for checking filling the cell
    private let solver: SudokuSolver
    /// indicate if there is mistakes currently
    private var isNoMistakes: Bool = true
    /// delegate for selecting cell
    public var delegate: SelectionProtocol?
    
    // MARK: - init()
    init(levelGame: String) {
        self.collectionViewSquares = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        answerMatrix = GeneratorOfMatrix.getAnswerMatrix()
        fieldMatrix = GeneratorOfMatrix.getMatrix(level: levelGame)
        solver = SudokuSolver(matrix: fieldMatrix)
        preFilled = []
        fieldNoteMatrix = []
        for i in 0...8 {
            self.preFilled.append([])
            self.fieldNoteMatrix.append([])
            for j in 0...8 {
                if (fieldMatrix[i][j] != 0) {
                    self.fieldNoteMatrix[i].append(nil)
                    self.preFilled[i].append(true)
                } else {
                    self.fieldNoteMatrix[i].append([false, false, false,
                                                    false, false, false,
                                                    false, false, false])
                    self.preFilled[i].append(false)
                }
            }
        }
        super.init(frame: .zero)
        setupView()
    }
    
    init(fieldState: FieldState) {
        self.collectionViewSquares = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.answerMatrix = fieldState.getAnswer()
        self.fieldMatrix = fieldState.getField()
        self.preFilled = fieldState.getPreFilled()
        self.solver = SudokuSolver(matrix: fieldMatrix)
        self.fieldNoteMatrix = fieldState.getNote()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Control functions
    /// Counts digits on the field
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
    
    public func isGameOverWithWin() -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                if (fieldMatrix[i][j] != answerMatrix[i][j]) {
                    return false
                }
            }
        }
        return true
    }
    
    public func isGameOver() -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                if (fieldMatrix[i][j] == 0) {
                    return false
                }
            }
        }
        return true
    }
    
    public func saveGame() -> FieldState {
        FieldState(field: fieldMatrix, preFilled: preFilled, answerMatrix: answerMatrix, fieldNote: fieldNoteMatrix)
    }
    
    public func undoToState(gameState: GameState) {
        self.fieldMatrix = gameState.getFieldState().getField()
        self.preFilled = gameState.getFieldState().getPreFilled()
        self.answerMatrix = gameState.getFieldState().getAnswer()
        self.fieldNoteMatrix = gameState.getFieldState().getNote()
        
        for s in collectionViewSquares.visibleCells {
            let square = s as! GameFieldSquare
            for c in square.collectionViewCells.visibleCells {
                let cell = c as! cellWithNumber
                let indexSquare = collectionViewSquares.indexPath(for: square)!
                let indexCell = (collectionViewSquares.cellForItem(at: indexSquare) as! GameFieldSquare).collectionViewCells.indexPath(for: cell)!
                let row = indexSquare.section * 3 + indexCell.section
                let col = indexSquare.row * 3 + indexCell.row
                let numb = fieldMatrix[row][col]
                let filled = preFilled[row][col]
                let note = fieldNoteMatrix[row][col]
                cell.configureNumber(numb: numb, filled: filled, note: note)
            }
        }
        refreshFromSelection()
        if (SettingsModel.isMistakesIndicates()) {
            highlightIncorrectNumber(isUndo: true)
        }
    }
    
    public func isNoMistakesInMatrix() -> Bool {
        isNoMistakes
    }
    
    internal func showMistakesAfterGame() {
        for i in 0...8 {
            for j in 0...8 {
                if (!isEqualWithAnswerMatrix(i, j)) {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber)
                    cell.setIsCorrectNumb(false)
                    cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.5)
                    delegate?.countUpMistakes()
                } else {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber)
                    cell.setIsCorrectNumb(true)
                    cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                }
            }
        }
    }
    
    internal func fillNotes() {
        solver.setMatrix(matrix: fieldMatrix)
        for i in 0...8 {
            for j in 0...8 {
                for num in 0...8 {
                    if (fieldMatrix[i][j] == 0 && solver.isValidPlaceForNum(row: i, col: j, num: num + 1)) {
                        if (fieldNoteMatrix[i][j] == nil) {
                            fieldNoteMatrix[i][j] = [false, false, false,
                                                     false, false, false,
                                                     false, false, false]
                        }
                        fieldNoteMatrix[i][j]?[num] = true
                        
                        let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare
                        let cell = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber
                        cell.configureNumber(numb: 0, filled: false, note: fieldNoteMatrix[i][j])
                    } else if (fieldMatrix[i][j] != 0) {
                        let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare
                        let cell = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber
                        cell.configureNumber(numb: fieldMatrix[i][j], filled: cell.getPreFilled(), note: nil)
                    }
                }
            }
        }
    }
    
    internal func getHint() -> (num: Int, row: Int, col: Int) {
        let solver = SudokuSolver(matrix: fieldMatrix)
        var num = -1, row = -1, col = -1
        solver.getOneNubmberForSolve(number: &num, row: &row, col: &col)
        if (num == -1) {
            return (num, row, col)
        } else {
            setHintOnTheField(num: num, row: row, col: col)
            return (num, row, col)
        }
    }
    
    internal func getRidOfInccorections() {
        for i in 0...8 {
            for j in 0...8 {
                if (!preFilled[i][j] && !isEqualWithAnswerMatrix(i, j)) {
                    let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare
                    let cell = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber
                    fieldMatrix[i][j] = 0
                    cell.setNumberLabel(numb: 0)
                    cell.setIsCorrectNumb(true)
                }
            }
        }
        highlightIncorrectNumber(isUndo: false)
    }
    
    /// Set number to the specific cell of the field matrix
    internal func setFieldMatrix(gameSquare: GameFieldSquare, row: Int, col: Int, num: Int) {
        if (!SettingsModel.isNoteOn()) {
            fieldMatrix[row][col] = num
            solver.setMatrix(matrix: fieldMatrix)
            let cellWithNumb = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: row % 3)) as! cellWithNumber
            cellWithNumb.setNumberLabel(numb: num)
            refreshFromSelection()
            
            if (SettingsModel.isMistakesIndicates()) {
                highlightIncorrectNumber(isUndo: false)
            }
            if (!isEqualWithAnswerMatrix(row, col)) {
                delegate?.countUpMistakes()
                isNoMistakes = false
            } else {
                isNoMistakes = true
            }
            if (SettingsModel.isAutoRemoveNoteOn()) {
                removeUnnessaryNotes()
            }
            tappedAtCell(fieldCellSelected: gameSquare, indexPathSelected: IndexPath(row: col % 3, section: row % 3))
        } else {
            let cellWithNumb = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: row % 3)) as! cellWithNumber
            if (num == 0) {
                cellWithNumb.setIsCorrectNumb(true)
                highlightIncorrectNumber(isUndo: false)
            } else {
                if (fieldNoteMatrix[row][col] == nil) {
                    fieldNoteMatrix[row][col] = cellWithNumb.getNoteNumbers()
                }
                fieldNoteMatrix[row][col]![num - 1].toggle()
            }
            cellWithNumb.setNoteNumbers(note: fieldNoteMatrix[row][col])
            cellWithNumb.setNumberLabel(numb: num)
            tappedAtCell(fieldCellSelected: gameSquare, indexPathSelected: IndexPath(row: col % 3, section: row % 3))
        }
    }
    
    /// Protocol function set numbers to cells after showing cells on the screen
    internal func setNumber(collectionView: UICollectionView, cell: cellWithNumber, indexPathWithNumb: IndexPath, cellInField: GameFieldSquare) {
        let indCellInField = collectionViewSquares.indexPath(for: cellInField)
        let row = (indCellInField?.section ?? 0) * 3 + indexPathWithNumb.section
        let col = (indCellInField?.row ?? 0) * 3 + indexPathWithNumb.row
        let num = fieldMatrix[row][col]
        let fill = preFilled[row][col]
        let note = fieldNoteMatrix[row][col]
        cell.configureNumber(numb: num, filled: fill, note: note)
    }
    
    /// Protocol function select cells (full row and col and square of selected cel)
    internal func tappedAtCell(fieldCellSelected: GameFieldSquare, indexPathSelected indexPath: IndexPath) {
        refreshFromSelection()
        var selectedNumber = ""
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldSquare
            if (sq == fieldCellSelected){
                for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                    if (sq?.collectionViewCells.cellForItem(at: indexPath) == cell) {
                        delegate?.setRowAndColumnOfSelection(fieldCellSelected, collectionViewSquares.indexPath(for: sq!)!.section * 3 + indexPath.section, collectionViewSquares.indexPath(for: sq!)!.row * 3 + indexPath.row, (cell as! cellWithNumber).getPreFilled())
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.7)
                        }
                        selectedNumber = (cell as? cellWithNumber)?.getNumber() ?? "0"
                    } else {
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
                        }
                    }
                }
            } else {
                let currIndex = collectionViewSquares.indexPath(for: sq ?? GameFieldSquare())
                let selectedIndex = collectionViewSquares.indexPath(for: fieldCellSelected)
                if currIndex != selectedIndex && currIndex?.row == selectedIndex?.row {
                    for k in 0..<3 {
                        let cell = sq?.collectionViewCells.cellForItem(at: IndexPath(row: indexPath.row, section: k))
                        if ((cell as? cellWithNumber)!.isCorrectNumber()){
                            cell?.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
                        }
                    }
                }
                if (currIndex != selectedIndex && currIndex?.section == selectedIndex?.section) {
                    for k in 0..<3 {
                        let cell = sq?.collectionViewCells.cellForItem(at: IndexPath(row: k, section: indexPath.section))
                        if ((cell as! cellWithNumber).isCorrectNumber()){
                            cell?.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
                        }
                    }
                }
            }
        }
        if (selectedNumber != "0" && selectedNumber != "" && SettingsModel.isHighlightingOn()) {
            highlightSameNumbers(selectedNumber: selectedNumber)
        }
    }
    
    /// Delete selection for all cells except the incorrect filled cells
    internal func refreshFromSelection() {
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldSquare
            for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                if ((cell as! cellWithNumber).isCorrectNumber()){
                    cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                    if (!(cell as! cellWithNumber).getPreFilled()) {
                        (cell as! cellWithNumber).setColorText(color: SettingsModel.getMainColor())
                    }
                }
                let c = (cell as! cellWithNumber)
                if (c.getPreFilled()) {
                    c.setColorText(color: SettingsModel.getMainLabelColor())
                } else {
                    c.setColorText(color: SettingsModel.getMainColor())
                }
            }
        }
    }
    
    /// set colors after changes
    internal func changeColor() {
        self.window?.changeColor()
        layer.borderColor = SettingsModel.getSecondaryLabelColor().cgColor
        backgroundColor = SettingsModel.getMainBackgroundColor()
        for square in collectionViewSquares.visibleCells {
            (square as? GameFieldSquare)?.changeColor()
        }
    }
    
    private func removeUnnessaryNotes() {
        solver.setMatrix(matrix: fieldMatrix)
        for i in 0...8 {
            for j in 0...8 {
                if (fieldNoteMatrix[i][j] != nil) {
                    for num in 0...8 {
                        if (fieldMatrix[i][j] == 0 && !solver.isValidPlaceForNum(row: i, col: j, num: num + 1)) {
                            let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare
                            let cell = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber
                            fieldNoteMatrix[i][j]?[num] = false
                            cell.configureNumber(numb: 0, filled: false, note: fieldNoteMatrix[i][j])
                        }
                    }
                }
            }
        }
    }
    
    private func setHintOnTheField(num: Int, row: Int, col: Int) {
        let game_square = collectionViewSquares.cellForItem(at: IndexPath(row: col / 3, section: row / 3)) as! GameFieldSquare
        let cell = game_square.collectionViewCells.cellForItem(at: IndexPath(row: col % 3, section: row % 3)) as! cellWithNumber
        cell.configureNumber(numb: num, filled: true, note: nil)
        answerMatrix[row][col] = num
        fieldMatrix[row][col] = num
        preFilled[row][col] = true
        fieldNoteMatrix[row][col] = nil
        refreshFromSelection()
        hintSetted(fieldSquare: game_square, coords: (row, col), number: num)
        if (SettingsModel.isAutoRemoveNoteOn()) {
            removeUnnessaryNotes()
        }
    }
    
    private func hintSetted(fieldSquare: GameFieldSquare, coords: (row: Int, col: Int), number: Int) {
        var indexes: [(row: Int, col: Int)] = []
        for i in 0...2 {
            let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: coords.col / 3, section: i)) as! GameFieldSquare
            if (gameSquare != fieldSquare) {
                let squarePath = collectionViewSquares.indexPath(for: gameSquare)
                for c in gameSquare.collectionViewCells.visibleCells {
                    let cell = c as! cellWithNumber
                    if (cell.getNumber() == String(number)) {
                        let path = gameSquare.collectionViewCells.indexPath(for: cell)
                        indexes.append((squarePath!.section * 3 + path!.section, squarePath!.row * 3 + path!.row))
                    }
                }
            }
        }
        for i in 0...2 {
            let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: i, section: coords.row / 3)) as! GameFieldSquare
            if (gameSquare != fieldSquare) {
                let squarePath = collectionViewSquares.indexPath(for: gameSquare)
                for c in gameSquare.collectionViewCells.visibleCells {
                    let cell = c as! cellWithNumber
                    if (cell.getNumber() == String(number)) {
                        let path = gameSquare.collectionViewCells.indexPath(for: cell)
                        indexes.append((squarePath!.section * 3 + path!.section, squarePath!.row * 3 + path!.row))
                    }
                }
            }
        }
        for index in indexes {
            let gameSquare = collectionViewSquares.cellForItem(at: IndexPath(row: index.col / 3, section: index.row / 3)) as! GameFieldSquare
            let cell = gameSquare.collectionViewCells.cellForItem(at: IndexPath(row: index.col % 3, section: index.row % 3)) as! cellWithNumber
            cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.7)
        }
        
        for c in fieldSquare.collectionViewCells.visibleCells {
            let cellPath = fieldSquare.collectionViewCells.indexPath(for: c as! cellWithNumber)
            let cell = c as! cellWithNumber
            if (cellPath!.section == coords.row % 3 && cellPath!.row == coords.col % 3) {
                cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.7)
            } else {
                cell.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.4)
            }
        }
    }
    
    /// Checks if filled number in the right place in the filed matrix (comparing with answer matrix)
    private func isEqualWithAnswerMatrix(_ row: Int, _ col: Int) -> Bool {
        if (fieldMatrix[row][col] == 0) {
            return true
        } else {
            return fieldMatrix[row][col] == answerMatrix[row][col]
        }
    }
    
    /// Checks if filled number in the right place in the filed matrix (comparing with answer matrix)
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
    
    /// Highlighting same numbers in the filed matrix
    private func highlightSameNumbers(selectedNumber: String) {
        for square in collectionViewSquares.visibleCells {
            let sq = square as? GameFieldSquare
            for cell in sq?.collectionViewCells.visibleCells ?? [UICollectionViewCell()] {
                guard let cellWithNumber = cell as? cellWithNumber else {continue}
                if (cellWithNumber.getNumber() == selectedNumber) {
                    if (cellWithNumber.isCorrectNumber()){
                        cellWithNumber.backgroundColor = SettingsModel.getMainColor().withAlphaComponent(0.7)
                    }
                }
            }
        }
    }
    
    /// Highlighting incrorrect filled numbers in the field matrix
    private func highlightIncorrectNumber(isUndo: Bool) {
        var incorretNumbers: [[IndexPath]] = []
        for i in 0...8 {
            for j in 0...8 {
                if (!isEqualWithAnswerMatrix(i, j)) {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber)
                    cell.setIsCorrectNumb(false)
                    cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.7)
                    incorretNumbers.append([IndexPath(row: j / 3, section: i / 3), IndexPath(row: j % 3, section: i % 3)])
                } else {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: j / 3, section: i / 3)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: j % 3, section: i % 3)) as! cellWithNumber)
                    cell.setIsCorrectNumb(true)
                    cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                }
            }
        }
        if (incorretNumbers.isEmpty) {
            isNoMistakes = true
        } else {
            isNoMistakes = false
        }
        for incorrect in incorretNumbers {
            let incorrectNum = ((collectionViewSquares.cellForItem(at: incorrect[0]) as! GameFieldSquare).collectionViewCells.cellForItem(at: incorrect[1]) as! cellWithNumber).getNumber()
            // in row
            for i in 0...2 {
                for j in 0...2 {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: i, section: incorrect[0].section)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: j, section: incorrect[1].section)) as! cellWithNumber)
                    if (cell.getNumber() == incorrectNum) {
                        cell.setIsCorrectNumb(false)
                        cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.5)
                    } else {
                        cell.setIsCorrectNumb(true)
                        cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                    }
                }
            }
            // in col
            for i in 0...2 {
                for j in 0...2 {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: incorrect[0].row, section: i)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: incorrect[1].row, section: j)) as! cellWithNumber)
                    if (cell.getNumber() == incorrectNum) {
                        cell.setIsCorrectNumb(false)
                        cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.5)
                    } else {
                        cell.setIsCorrectNumb(true)
                        cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                    }
                }
            }
            // in square
            for i in 0...2 {
                for j in 0...2 {
                    let cell = ((collectionViewSquares.cellForItem(at: IndexPath(row: incorrect[0].row, section: incorrect[0].section)) as! GameFieldSquare).collectionViewCells.cellForItem(at: IndexPath(row: i, section: j)) as! cellWithNumber)
                    if (cell.getNumber() == incorrectNum) {
                        cell.setIsCorrectNumb(false)
                        cell.backgroundColor = SettingsModel.getIncorrectColor().withAlphaComponent(0.5)
                    } else {
                        cell.setIsCorrectNumb(true)
                        cell.backgroundColor = SettingsModel.getMainBackgroundColor()
                    }
                }
            }
        }
    }
    
    // MARK: - setup UI for view
    private func setupView() {
        layer.borderColor = SettingsModel.getMainLabelColor().cgColor
        layer.borderWidth = 1.5
        backgroundColor = SettingsModel.getMainBackgroundColor()
        collectionViewSquares.delegate = self
        collectionViewSquares.dataSource = self
        collectionViewSquares.isScrollEnabled = false
        collectionViewSquares.register(GameFieldSquare.self, forCellWithReuseIdentifier: GameFieldSquare.reuseIdentifier)
        addSubview(collectionViewSquares)
        collectionViewSquares.pin(to: self, [.top, .bottom, .left, .right])
    }
}


// MARK: - extensions
extension GameFieldView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // dequeue the standard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameFieldSquare.reuseIdentifier, for: indexPath)
        (cell as! GameFieldSquare).delegateTap = self
        (cell as! GameFieldSquare).delegateSetNumber = self
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

