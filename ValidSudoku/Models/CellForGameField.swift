//
//  CellForGameField.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

// MARK: - Game field square
final class GameFieldSquare: UICollectionViewCell {
    
    // MARK: - Variables
    /// identifier for cell
    public static let reuseIdentifier = "GameFieldCell"
    /// delegate for processing tap in the cell
    public var delegateTap: CellTappedProtocol?
    /// delegate for setting number after cell appear on the screen
    public var delegateSetNumber: setNumbersProtocol?
    /// cells in the squares
    internal let collectionViewCells = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    internal func changeColor() {
        layer.borderColor = SettingsModel.isDarkMode() ? CGColor(red: 1, green: 1, blue: 1, alpha: 1) : CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backgroundColor = SettingsModel.getMainBackgroundColor()
    }
    
    // MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup UI
    private func setupView() {
        layer.borderColor = SettingsModel.isDarkMode() ? CGColor(red: 1, green: 1, blue: 1, alpha: 1) : CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        layer.borderWidth = 0.5
        backgroundColor = SettingsModel.getMainBackgroundColor()
        collectionViewCells.dataSource = self
        collectionViewCells.delegate = self
        collectionViewCells.register(cellWithNumber.self, forCellWithReuseIdentifier: cellWithNumber.reuseIdentifier)
        addSubview(collectionViewCells)
        collectionViewCells.backgroundColor = .white.withAlphaComponent(0.01)
        collectionViewCells.pin(to: self, [.top, .bottom, .right, .left])
        collectionViewCells.isScrollEnabled = false
    }
    
}

// MARK: - extensions
extension GameFieldSquare: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellWithNumber.reuseIdentifier, for: indexPath)
        return cell
    }
    
}

extension GameFieldSquare: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateSetNumber?.setNumber(collectionView: collectionView, cell: cell as? cellWithNumber ?? cellWithNumber(), indexPathWithNumb: indexPath, cellInField: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateTap?.tappedAtCell(fieldCellSelected: self, indexPathSelected: indexPath)
    }
}

extension GameFieldSquare: UICollectionViewDelegateFlowLayout {
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
