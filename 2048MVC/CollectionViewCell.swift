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
    var cellPoints:Int = 0
    var cellPointsHistory:Int = 0
    var cellColor:UIColor = .blue
    
    
    func setup(cellNumber:Int) {
        self.cellNumber = cellNumber
        let image = UIImage(named: "180")
        cellImage.image = image
        cellImage.alpha = 0.4
        cellImage.backgroundColor = cellColor
        allCells.append(self)
        pointsLabel.text = ""
    }
    
    func paint() {
        switch pointsLabel.text {
            case "2":
                cellColor = .red
            case "4":
                cellColor = .green
            case "8":
                cellColor = .white
            case "16":
                cellColor = .gray
            case "32":
                cellColor = .orange
            case "64":
                cellColor = .green
            case "128":
                cellColor = .brown
            case "256":
                cellColor = .magenta
            case "512":
                cellColor = .black
            case "1024":
                cellColor = .gray
            case "2048":
                cellColor = .brown
            default:
                cellColor = .blue
        }
    }
}
