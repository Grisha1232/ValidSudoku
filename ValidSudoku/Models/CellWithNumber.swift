//
//  CellWithNumber.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

final class cellWithNumber: UICollectionViewCell {
    static let reuseIdentifier = "CellWithNumber"
    
    private let numberLabel = UILabel()
    private var preFilled: Bool = true
    private var isCorrectNumb: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getPreFilled() -> Bool {
        return preFilled
    }
    
    public func getNumber() -> String {
        return numberLabel.text ?? ""
    }
    
    public func isCorrectNumber() -> Bool {
        isCorrectNumb
    }
    
    public func setColorText(color: UIColor) {
        numberLabel.textColor = color
    }
    
    internal func setIsCorrectNumb(_ val: Bool) {
        isCorrectNumb = val
    }
    
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
    
    public func configureNumber(numb: Int) {
        if numb == 0 {
            numberLabel.text = ""
            preFilled = false
        } else {
            preFilled = true
            numberLabel.text = String(numb)
        }
    }
    
    public func setNumberLabel(numb: Int) {
        if numb == 0 {
            numberLabel.text = ""
        } else {
            numberLabel.text = String(numb)
            numberLabel.textColor = SettingsModel.getMainColor()
        }
    }
}
