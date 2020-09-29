//
//  2048Controller.swift
//  2048MVC
//
//  Created by eyal avisar on 15/09/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//
//git remote add origin https://github.com/EyalAvisar75/2048MVC.git
//git push -u origin master
import UIKit
import ViewAnimator

extension MatrixController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4 - 4, height: collectionView.frame.height / 4 - 4)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if squaresContentHistory != squaresContent.description {
                getNewTileContent()
            }
            
            if checkGameEnded()
                {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
                    
                    let alert = UIAlertController(title: "Game Ended!", message: "", preferredStyle: .alert)
                    let endAction = UIAlertAction(title: "Continue", style: .default) { (sender:UIAlertAction) in
                        self.restartGame(self.endGame!)
                    }
                    alert.addAction(endAction)
                    present(alert, animated: true)
                    
                    return cell
                }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.setup(cellNumber: indexPath.row)
        animateShift(cell: cell)

        if squaresContent[indexPath.row] != 0 {
            cell.pointsLabel.text = String(squaresContent[indexPath.row])
        }
        
        cell.paint()
        cell.cellImage.backgroundColor = cell.cellColor
        
        if cell.backgroundColor != cell.pointsLabel.backgroundColor {
            cell.pointsLabel.backgroundColor = cell.backgroundColor
        }
        return cell
    }
}

class MatrixController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var endGame: UIButton!
    @IBOutlet weak var numbersCollection: UICollectionView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    var endGoal = false
    var direction:Direction = .Right
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numbersCollection.delegate = self
        numbersCollection.dataSource = self
        
        // Swipe (right and left)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        
        swipeUpGesture.direction = UISwipeGestureRecognizer.Direction.up
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeUpGesture)
        view.addGestureRecognizer(swipeDownGesture)
        
        run()

    }

    @IBAction func restartGame(_ sender: Any) {
        squaresContent = []
        squaresContentHistory = ""
        run()
        UIView.transition(with: numbersCollection,
        duration: 0.35,
        options: .transitionCrossDissolve,
        animations: { self.numbersCollection.reloadData() })
    }
    
    func run() {
        endGoal = false
        squaresContent = Array(repeating: 0, count: 15)
        let value = Bool.random() ? 2 : 4
        squaresContent.append(value)
        squaresContent.shuffle()
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {

        squaresContentHistory = squaresContent.description
        
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            direction = .Right
            shiftContentRight()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left
        {
            direction = .Left
            shiftContentLeft()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up
        {
            direction = .Up
            shiftContentUp()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down
        {
            direction = .Down
            shiftContentDown()
        }
        
        accumulatePoints()
        self.numbersCollection.reloadData()

        if !endGoal && squaresContent.contains(32) {
            let alert = UIAlertController(title: "Congratulations", message: "You have reached 2048", preferredStyle: .alert)
            let dismmisAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alert.addAction(dismmisAction)
            present(alert, animated: true)
            endGoal = true
        }
    }

    func accumulatePoints() {
        let pointsLabelComponents = pointsLabel.text?.components(separatedBy: " ")
        
        let current = Int(pointsLabelComponents![1])
        pointsLabel.text = "Points \(current! + pointsToAdd)"
        
        pointsToAdd = 0

    }

    func animateShift(cell:CollectionViewCell) {
        
//        UIView.transition(with: numbersCollection, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)

        var cellsToAnimate = [CollectionViewCell]()

        if direction == .Down {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromTop, animations: {
            },
            completion: nil)
        }
        else if direction == .Up {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromBottom, animations: {
            },
            completion: nil)
        }
        else if direction == .Left {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromRight, animations: {
            },
            completion: nil)
        }
        else if direction == .Right {
            UIView.transition(with: cell.pointsLabel, duration: 0.25, options: .transitionFlipFromLeft, animations: {
            },
            completion: nil)
        }
        
        if changedCells.count != 0 {
            for index in changedCells {
                for member in allCells {
                    if member.cellNumber == index && squaresContent[index] > 2 {
                        cellsToAnimate.append(member)   
                    }
                }
            }
        }
        
        if cellsToAnimate.contains(cell) {
            UIView.animate(withDuration: 6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                cell.cellImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                cell.cellImage.transform = .identity
            })
            
            for index in 0..<changedCells.count {
                if changedCells[index]  == cell.cellNumber {
                    changedCells.remove(at: index)
                    break
                }
            }
            cellsToAnimate = []
        }
    }
    
    func checkGameEnded() -> Bool {
        var index = 0
            while index <= 11 {
                if squaresContent[index + 4] == squaresContent[index] {
                    return false
                }
                
                index += 4
                if index > 11 && index != 15 {
                    index -= 11
                }
            }
        
        index = 0
            
            while index < 15 {
                if index % 4 < 3 && squaresContent[index] ==  squaresContent[index + 1] {
                    return false
                }
                index += 1
            }
        
        return true
    }
}

