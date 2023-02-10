//
//  setNumbersProtocol.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/27/23.
//

import UIKit

protocol setNumbersProtocol {
    func setNumber(collectionView: UICollectionView, cell: cellWithNumber, indexPathWithNumb: IndexPath, cellInField: GameFieldSquare)
}
