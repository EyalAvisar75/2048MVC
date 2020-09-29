//
//  CollectionViewCell.swift
//  My2048
//
//  Created by eyal avisar on 08/09/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    var cellNumber:Int?
    var cellPointsHistory:Int = 0
    var cellColor:UIColor = .blue
    
    func setup(cellNumber:Int) {
        self.cellNumber = cellNumber
        let image = UIImage(named: "180")
        cellImage.image = image
        cellImage.alpha = 0.4
        cellImage.backgroundColor = cellColor
        allCells.insert(self)
        pointsLabel.text = ""
    }
    
    func paint() {
        
        let points = Int(pointsLabel.text!) ?? 0 % 4096
        
        switch points {
            case 2:
                cellColor = .green
            case 4:
                cellColor = .red
            case 8:
                cellColor = .yellow
            case 16:
                cellColor = .white
            case 32:
                cellColor = .magenta
            case 64:
                cellColor = .orange
            case 128:
                cellColor = .cyan
            case 256:
                cellColor = .gray
            case 512:
                cellColor = .brown
            case 1024:
                cellColor = .lightGray
            case 2048:
                cellColor = .purple
            default:
                cellColor = .blue
        }
    }
}
