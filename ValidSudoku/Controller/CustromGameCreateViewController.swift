//
//  CustromGameCreateViewController.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 4/24/23.
//

import UIKit

class CustomGameCreateViewController: UIViewController , ChangedColorProtocol, SelectionProtocol {
    
    private let createBtn = UIButton.makeNewButton(title: "Check and Create")
    private let field = GameFieldView()
    private let lineDigitsStackView = UIStackView()
    private var digitsCount: [Int] = []
    
    private var selectedRow: Int = -1
    private var selectedCol: Int = -1
    private var selectedSquare: GameFieldSquare? = nil
    
    public var delegate: CreateCustomGameProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupUI();
    }
    
    internal func changeColor() {
        print("change")
    }
    
    
    internal func setRowAndColumnOfSelection(_ gameSquare: GameFieldSquare, _ row: Int, _ col: Int, _ preFilled: Bool) {
        selectedRow = row
        selectedCol = col
        selectedSquare = gameSquare
    }
    
    internal func countUpMistakes() {
        print("nope")
    }
    
    private func setupUI() {
        view.backgroundColor = SettingsModel.getMainBackgroundColor()
        SettingsModel.appendTo(content: self)
        
        setupCreateButton()
        
        setupLineDigits()
        
        setupField()
        
        setupEraseButton()
    }
    
    private func setupCreateButton() {
        
        createBtn.addTarget(self, action: #selector(checkAndCreateBtnTapped(_:)), for: .touchUpInside)
        
        view.addSubview(createBtn)
        createBtn.pin(to: view, [.left: 16, .right: 16])
        createBtn.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        
    }
    
    private func setupField() {
        view.addSubview(field)
        
        field.delegate = self
        
        field.pin(to: view, [.left: 16, .right: 16])
        
        field.setWidth(view.frame.width - 32)
        field.setHeight(view.frame.width - 32)
        
        field.pinCenterY(to: view.safeAreaLayoutGuide.centerYAnchor)
    }
    
    private func setupLineDigits() {
        view.addSubview(lineDigitsStackView)
        digitsCount = field.countDigitInMatrix()
        for i in 0..<9 {
            let button = UIButton()
            button.setTitle(String(i + 1), for: .normal)
            button.tag = i + 1
            button.setTitleColor(SettingsModel.getMainColor(), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 32)
            button.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
            if (digitsCount[i] == 9) {
                button.isEnabled = false
                button.setTitleColor(SettingsModel.getSecondaryBackgroundColor() , for: .normal)
            }
            lineDigitsStackView.addArrangedSubview(button)
        }
        lineDigitsStackView.axis         = .horizontal
        lineDigitsStackView.alignment    = .center
        lineDigitsStackView.distribution = .equalSpacing
        lineDigitsStackView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
        lineDigitsStackView.pin(to: view, [.left: 16, .right: 16])
        lineDigitsStackView.setHeight(60)
    }
    
    private func setupEraseButton() {
        let eraseView = UIView()
        let button = UIButton()
        let label = UILabel()
        
        eraseView.addSubview(button)
        eraseView.addSubview(label)
        
        button.setBackgroundImage(.init(systemName: "delete.left"), for: .normal)
        button.tintColor = SettingsModel.getMainLabelColor()
        button.addTarget(self, action: #selector(eraseButtonTapped(_:)), for: .touchUpInside)
        
        label.text = "erase"
        label.textAlignment = .center
        label.textColor = SettingsModel.getMainLabelColor()
        label.font = .systemFont(ofSize: 14)
        
        button.pin(to: eraseView, [.left, .right, .top])
        button.pinBottom(to: label.topAnchor, 5)
        label.pin(to: eraseView, [.left, .right, .bottom])
        
        
        button.setHeight(40)
        eraseView.setWidth(45)
        
        view.addSubview(eraseView)
        
        eraseView.pinTop(to: field.bottomAnchor, 32)
        eraseView.pinBottom(to: lineDigitsStackView.topAnchor)
        eraseView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 32)
    }
    
    @objc private func checkAndCreateBtnTapped(_ sender: UIButton) {
        let solver = SudokuSolver(matrix: field.getMatrix())
        var count = 0
        if (solver.checkMatrixOnCorrection()) {
            solver.countSoln(number: &count)
            if (count >= 2) {
                print("invalid 1")
                let alert = UIAlertController(title: "Invalid sudoku", message: "Your sudoku has 2 or more solution. Please find a new sudoku or just use our game creator.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                let field = field.getMatrix()
                let solver = SudokuSolver(matrix: field)
                _ = solver.solveSudoku()
                let answer = solver.matrix
                self.dismiss(animated: true)
                delegate?.customGameCreate(field: field, answer: answer)
                print("creating new game")
            }
        } else {
            print("invalid 2")
            let alert = UIAlertController(title: "Invalid sudoku", message: "Your sudoku has invalid position(s). Please make corretions or just use our game creator.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    @objc private func eraseButtonTapped(_ sender: UIButton) {
        if (selectedRow != -1 && selectedCol != -1) {
            field.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: 0)
            digitsCount = field.countDigitInMatrix()
            for i in 0...8 {
                if (digitsCount[i] == 9) {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
                } else {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = true
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.isNoteOn() ? SettingsModel.getSecondaryLabelColor() : SettingsModel.getMainColor(), for: .normal)
                }
            }
        }
    }
    
    @objc private func numberTapped(_ sender: UIButton) {
        if (selectedCol != -1 && selectedRow != -1) {
            field.setFieldMatrix(gameSquare: selectedSquare!, row: selectedRow, col: selectedCol, num: sender.tag)
            
            digitsCount = field.countDigitInMatrix()
            var count = 0
            for i in 0...8 {
                if (digitsCount[i] == 9) {
                    count += 1
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = false
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getSecondaryBackgroundColor(), for: .normal)
                } else {
                    (lineDigitsStackView.subviews[i] as! UIButton).isEnabled = true
                    (lineDigitsStackView.subviews[i] as! UIButton).setTitleColor(SettingsModel.getMainColor(), for: .normal)
                }
            }
        }
    }
}
