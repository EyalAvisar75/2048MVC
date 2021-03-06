//
//  MatrixModel.swift
//  2048MVC
//
//  Created by eyal avisar on 15/09/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import Foundation
//in a new project - work on empty collectionview and try to animate cell movement
var squaresContent:[Int] = [] //Array(repeating: 0, count: 15) maybe i should fill it as 2 dimensional array?
var squaresContentHistory = ""
var changedCells = [Int]()
var allCells:Set<CollectionViewCell> = []
var pointsToAdd = 0

func shiftContentLeft()  {
    closeSquareContentGapsLeft()
    sumPointsLeft()
    closeSquareContentGapsLeft()
}

func shiftContentRight() {
    closeSquareContentGapsRight()
    sumPointsRight()
    closeSquareContentGapsRight()
}

func shiftContentUp() {
    closeSquareContentGapsUp()
    sumPointsUp()
    closeSquareContentGapsUp()
}

func shiftContentDown() {
    closeSquareContentGapsDown()
    sumPointsDown()
    closeSquareContentGapsDown()
}

func sumPointsRight() {
    var index = 15
    
    while index > 0 {
        if index % 4 > 0 && squaresContent[index] ==  squaresContent[index - 1] {
            squaresContent[index] *= 2
            squaresContent[index - 1] = 0
            
            if squaresContent[index] > 0 {
                changedCells.append(index)
                add(points: squaresContent[index])
            }
            
            index -= 2
            continue
        }
        index -= 1
    }
}

func closeSquareContentGapsRight() {
    var index = 0
    while index < 15 {
        if index % 4  < 3 && squaresContent[index] > 0 && squaresContent[index + 1] == 0 {
            squaresContent[index + 1] = squaresContent[index]
            squaresContent[index] = 0
            index = 0
            continue
        }
        
        index += 1
    }

}

func sumPointsLeft() {
    var index = 0
    
    while index < 15 {
        if index % 4 < 3 && squaresContent[index] ==  squaresContent[index + 1] {
            squaresContent[index + 1] *= 2
            squaresContent[index] = 0
            
            if squaresContent[index + 1] > 0 {
                changedCells.append(index + 1)
                add(points: squaresContent[index])
            }
            
            index += 2
            continue
        }
        index += 1
    }
}

func closeSquareContentGapsLeft() {
    var index = 15
    while index > 0 {
        if index % 4  > 0 && squaresContent[index] > 0 && squaresContent[index - 1] == 0 {
            squaresContent[index - 1] = squaresContent[index]
            squaresContent[index] = 0
            index = 15
            continue
        }
        index -= 1
    }
}

func sumPointsDown() {
    var index = 15
    while index >= 4 {
        if squaresContent[index - 4] == squaresContent[index] {
            squaresContent[index] *= 2
            squaresContent[index - 4] = 0
            
            if squaresContent[index] > 0 {
                changedCells.append(index)
                add(points: squaresContent[index])
//                accumulatePoints(with: squaresContent[index])
            }
        }
        
        index -= 4
        if index < 4 && index != 0 {
            index += 11
        }
    }

}

func closeSquareContentGapsDown() {
    var index = 15
    while index >= 4 {
        if squaresContent[index - 4] != 0 && squaresContent[index] == 0{
            squaresContent[index] = squaresContent[index - 4]
            squaresContent[index - 4] = 0
            index = 15
            continue
        }
        
        index -= 4
        if index < 4 && index != 0 {
            index %= 4
            index += 11
        }
    }
}

func sumPointsUp() {
    var index = 0
    while index <= 11 {
        if squaresContent[index + 4] == squaresContent[index] {
            squaresContent[index] *= 2
            squaresContent[index + 4] = 0
            if squaresContent[index] > 0 {
                changedCells.append(index)
                add(points: squaresContent[index])
            }
        }
        
        index += 4
        if index > 11 && index != 15 {
            index -= 11
        }
    }

}

func closeSquareContentGapsUp() {
    var index = 0
    while index <= 11 {
        if squaresContent[index] == 0 && squaresContent[index + 4] != 0{
            squaresContent[index] = squaresContent[index + 4]
            squaresContent[index + 4] = 0
            index = 0
            continue
        }
        
        index += 4
        if index > 11 && index != 15 {
            index %= 4
            index += 1
        }
    }
}

func getNewTileContent() {
    var insertedANumber = false
    while !insertedANumber {
        let index = Int.random(in: 0..<16)
        if squaresContent[index] == 0 {
            squaresContent[index] = Bool.random() ? 2 : 4
            insertedANumber = true
        }
    }
}

func add(points:Int) {
    pointsToAdd += points
}
