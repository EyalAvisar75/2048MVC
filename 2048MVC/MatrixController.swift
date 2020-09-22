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
//            print(squaresContentHistory)
//            print(squaresContent)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        animateShift(cell: cell)
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            cell.cellImage.transform = .identity
        })
        cell.setup(cellNumber: indexPath.row)
        
        if squaresContent[indexPath.row] != 0 {
            cell.pointsLabel.text = String(squaresContent[indexPath.row])
        }
        
        cell.paint()
        cell.cellImage.backgroundColor = cell.cellColor
//        cell.backgroundColor = cell.cellColor
        
        
        if cell.backgroundColor != cell.pointsLabel.backgroundColor {
            cell.pointsLabel.backgroundColor = cell.backgroundColor
        }
        return cell
    }
}

class MatrixController: UIViewController, UICollectionViewDelegate {

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
        
        UIView.transition(with: numbersCollection, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)

        var cellsToAnimate = [CollectionViewCell]()

        if changedCells.count != 0 {
            for index in changedCells {
                cellsToAnimate.append(allCells[index])
            }
        }
        
        if cellsToAnimate.contains(cell) {
            UIView.animate(withDuration: 6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                cell.cellImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            cellsToAnimate = []
        }
    }
        
}

