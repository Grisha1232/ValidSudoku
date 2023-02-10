//
//  CellForGameField.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

final class GameFieldCell: UICollectionViewCell {
    static let reuseIdentifier = "GameFieldCell"
    public var delegateTap: CellTappedProtocol?
    public var delegateSetNumber: setNumbersProtocol?
    
    internal let collectionViewCells = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        layer.borderWidth = 0.5
        backgroundColor = .white
        collectionViewCells.dataSource = self
        collectionViewCells.delegate = self
        collectionViewCells.register(cellWithNumber.self, forCellWithReuseIdentifier: cellWithNumber.reuseIdentifier)
        addSubview(collectionViewCells)
        collectionViewCells.backgroundColor = .white.withAlphaComponent(0.01)
        collectionViewCells.pin(to: self, [.top, .bottom, .right, .left])
        collectionViewCells.isScrollEnabled = false
    }
    
}

extension GameFieldCell: UICollectionViewDataSource {
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

extension GameFieldCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateSetNumber?.setNumber(collectionView: collectionView, cell: cell as? cellWithNumber ?? cellWithNumber(), indexPathWithNumb: indexPath, cellInField: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateTap?.tappedAtCell(fieldCellSelected: self, indexPathSelected: indexPath)
    }
}

extension GameFieldCell: UICollectionViewDelegateFlowLayout {
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
