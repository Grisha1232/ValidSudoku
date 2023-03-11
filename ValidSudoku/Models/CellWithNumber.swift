//
//  CellWithNumber.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

// MARK: - cell with number
final class cellWithNumber: UICollectionViewCell, ChangedColorProtocol {
    
    // MARK: - Variables
    /// indentifier
    public static let reuseIdentifier = "CellWithNumber"
    
    private let numberLabel = UILabel()
    private var noteNumbers: [Bool] = [false, false, false,
                                       false, false, false,
                                       false, false, false]
    private let noteNumbersLabel: [UILabel] = [UILabel(), UILabel(), UILabel(),
                                               UILabel(), UILabel(), UILabel(),
                                               UILabel(), UILabel(), UILabel()]
    
    /// indicates this cell is filled by game or by user
    private var preFilled: Bool = true
    /// indicates this cell is filled correctly or not
    private var isCorrectNumb: Bool = true
    
    
    // MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        SettingsModel.appendTo(content: self)
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Control functions
    
    /// get wether this cell preFilled or not
    public func getPreFilled() -> Bool {
        return preFilled
    }
    
    /// get the number filled in the cell ("1"..."9" or "")
    public func getNumber() -> String {
        return numberLabel.text ?? ""
    }
    
    /// get wether this number correct filled or not
    public func isCorrectNumber() -> Bool {
        isCorrectNumb
    }
    
    /// set color of the text after changing the color in the "SettingsViewController"
    public func setColorText(color: UIColor) {
        numberLabel.textColor = color
    }
    
    public func setNoteNumbers(note: [Bool]?) {
        if let n = note {
            noteNumbers = n
        }
    }
    
    public func getNoteNumbers() -> [Bool] {
        noteNumbers
    }
    
    /// set is it cell filled correct or not
    internal func setIsCorrectNumb(_ val: Bool) {
        isCorrectNumb = val
    }
    
    
    internal func changeColor() {
        self.window?.changeColor()
        if (isCorrectNumber()) {
            backgroundColor = SettingsModel.getMainBackgroundColor()
        }
        layer.borderColor = SettingsModel.getSecondaryLabelColor().cgColor
        if (preFilled) {
            numberLabel.textColor = SettingsModel.getMainLabelColor()
        } else {
            numberLabel.textColor = SettingsModel.getMainColor()
        }
        for i in 0...8 {
            noteNumbersLabel[i].textColor = SettingsModel.getSecondaryLabelColor()
        }
    }
    
    // MARK: - setup UI
    private func setupView() {
        layer.borderColor = SettingsModel.getSecondaryLabelColor().cgColor
        layer.borderWidth = 0.3
        addSubview(numberLabel)
        backgroundColor = SettingsModel.getMainBackgroundColor()
        backgroundView?.alpha = 0;
        numberLabel.pin(to: self, [.right, .left, .bottom, .top])
        numberLabel.textColor = SettingsModel.getMainLabelColor()
        numberLabel.textAlignment = .center
        numberLabel.text = "0"
        numberLabel.font = .systemFont(ofSize: self.frame.width / 2)
        for i in 0...8 {
            addSubview(noteNumbersLabel[i])
            noteNumbersLabel[i].text = String(i + 1);
            noteNumbersLabel[i].textColor = SettingsModel.getSecondaryLabelColor()
            noteNumbersLabel[i].font = .systemFont(ofSize: self.frame.width / 3)
            noteNumbersLabel[i].isHidden = true
        }
        noteNumbersLabel[0].pin(to: self, [.left: 2, .top: 0])
        noteNumbersLabel[0].setHeight(self.frame.height / 3)
        noteNumbersLabel[0].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[1].pinLeft(to: noteNumbersLabel[0].trailingAnchor)
        noteNumbersLabel[1].pinTop(to: self.topAnchor)
        noteNumbersLabel[1].setHeight(self.frame.height / 3)
        noteNumbersLabel[1].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[2].pinLeft(to: noteNumbersLabel[1].trailingAnchor)
        noteNumbersLabel[2].pinTop(to: self.topAnchor)
        noteNumbersLabel[2].setHeight(self.frame.height / 3)
        noteNumbersLabel[2].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[3].pin(to: self, [.left: 2])
        noteNumbersLabel[3].pinTop(to: noteNumbersLabel[0].bottomAnchor)
        noteNumbersLabel[3].setHeight(self.frame.height / 3)
        noteNumbersLabel[3].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[4].pinLeft(to: noteNumbersLabel[3].trailingAnchor)
        noteNumbersLabel[4].pinTop(to: noteNumbersLabel[1].bottomAnchor)
        noteNumbersLabel[4].setHeight(self.frame.height / 3)
        noteNumbersLabel[4].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[5].pinLeft(to: noteNumbersLabel[4].trailingAnchor)
        noteNumbersLabel[5].pinTop(to: noteNumbersLabel[2].bottomAnchor)
        noteNumbersLabel[5].setHeight(self.frame.height / 3)
        noteNumbersLabel[5].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[6].pin(to: self, [.left: 2])
        noteNumbersLabel[6].pinTop(to: noteNumbersLabel[3].bottomAnchor)
        noteNumbersLabel[6].setHeight(self.frame.height / 3)
        noteNumbersLabel[6].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[7].pinLeft(to: noteNumbersLabel[6].trailingAnchor)
        noteNumbersLabel[7].pinTop(to: noteNumbersLabel[4].bottomAnchor)
        noteNumbersLabel[7].setHeight(self.frame.height / 3)
        noteNumbersLabel[7].setWidth(self.frame.width / 3)
        
        noteNumbersLabel[8].pinLeft(to: noteNumbersLabel[7].trailingAnchor)
        noteNumbersLabel[8].pinTop(to: noteNumbersLabel[5].bottomAnchor)
        noteNumbersLabel[8].setHeight(self.frame.height / 3)
        noteNumbersLabel[8].setWidth(self.frame.width / 3)
    }
    
    /// configure cell after appearing on the screen
    public func configureNumber(numb: Int, filled: Bool, note: [Bool]?) {
        if (filled) {
            preFilled = true
            numberLabel.text = String(numb)
            for i in 0...8 {
                noteNumbersLabel[i].isHidden = true
            }
        } else {
            preFilled = false
            if (numb == 0) {
                numberLabel.text = ""
                noteNumbers = note ?? []
                if (note != nil) {
                    for i in 0...8 {
                        if (noteNumbers[i]) {
                            noteNumbersLabel[i].isHidden = false
                        } else {
                            noteNumbersLabel[i].isHidden = true
                        }
                    }
                } else {
                    for i in 0...8 {
                        noteNumbersLabel[i].isHidden = true
                    }
                }
            } else {
                numberLabel.text = String(numb)
                numberLabel.textColor = SettingsModel.getMainColor()
            }
        }
    }
    
    /// set number by user
    public func setNumberLabel(numb: Int) {
        if (!SettingsModel.isNoteOn()) {
            if numb == 0 {
                numberLabel.text = ""
            } else {
                numberLabel.text = String(numb)
                numberLabel.textColor = SettingsModel.getMainColor()
                for i in 0...8 {
                    noteNumbersLabel[i].isHidden = true
                }
            }
        } else {
            if (numberLabel.text == "" && numb != 0) {
                noteNumbersLabel[numb - 1].isHidden.toggle()
            }
            if (numb == 0) {
                numberLabel.text = ""
            }
        }
    }
}
