//
//  CellWithNumber.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

// MARK: - cell with number
final class cellWithNumber: UICollectionViewCell {
    
    // MARK: - Variables
    /// indentifier
    public static let reuseIdentifier = "CellWithNumber"
    
    private let numberLabel = UILabel()
    
    /// indicates this cell is filled by game or by user
    private var preFilled: Bool = true
    /// indicates this cell is filled correctly or not
    private var isCorrectNumb: Bool = true
    
    
    // MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    /// set is it cell filled correct or not
    internal func setIsCorrectNumb(_ val: Bool) {
        isCorrectNumb = val
    }
    
    // MARK: - setup UI
    private func setupView() {
        layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        layer.borderWidth = 0.3
        addSubview(numberLabel)
        backgroundColor = .red.withAlphaComponent(0)
        backgroundView?.alpha = 0;
        numberLabel.pin(to: self, [.right, .left, .bottom, .top])
        numberLabel.textColor = .label
        numberLabel.textAlignment = .center
        numberLabel.text = "0"
        numberLabel.font = .systemFont(ofSize: self.frame.width / 2)
    }
    
    /// configure cell after appearing on the screen
    public func configureNumber(numb: Int) {
        if numb == 0 {
            numberLabel.text = ""
            preFilled = false
        } else {
            preFilled = true
            numberLabel.text = String(numb)
        }
    }
    
    /// set number by user
    public func setNumberLabel(numb: Int) {
        if numb == 0 {
            numberLabel.text = ""
        } else {
            numberLabel.text = String(numb)
            numberLabel.textColor = SettingsModel.getMainColor()
        }
    }
}
