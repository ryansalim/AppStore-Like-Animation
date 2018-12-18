//
//  ViewController.swift
//  TestAppStoreAnimation
//
//  Created by Ryan Salim on 12/12/18.
//  Copyright © 2018 Ryan Salim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var expandedCell: ExpandableCell?
    private var isStatusBarHidden = false
    private var hiddenCells = [ExpandableCell]()
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let currentBundle = Bundle(for: ViewController.self)
        collectionView.register(UINib(nibName: "ExpandableCell", bundle: currentBundle), forCellWithReuseIdentifier: "ExpandableCell")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dampingRatio: CGFloat = 0.8
        let initialVelocity = CGVector.zero
        let springParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
        
        self.view.isUserInteractionEnabled = false
        
        if let selectedCell = expandedCell {
            isStatusBarHidden = false
            
            animator.addAnimations {
                selectedCell.collapse()
                self.hiddenCells.forEach({ $0.show() })
            }
            
            animator.addCompletion { _ in
                self.collectionView.isScrollEnabled = true
                self.expandedCell = nil
                self.hiddenCells.removeAll()
            }
        } else {
            isStatusBarHidden = true
            
            collectionView.isScrollEnabled = false
            
            let selectedCell = collectionView.cellForItem(at: indexPath)! as! ExpandableCell
            let frameOfSelectedCell = selectedCell.frame
            
            expandedCell = selectedCell
            hiddenCells = collectionView.visibleCells.map({ $0 as! ExpandableCell}).filter({ $0 != selectedCell})
            
            animator.addAnimations {
                selectedCell.expand(in: collectionView)
                self.hiddenCells.forEach({ $0.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)})
            }
        }
        
        animator.addAnimations {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        animator.addCompletion { _ in
            self.view.isUserInteractionEnabled = true
        }
        
        animator.startAnimation()
    }
}
