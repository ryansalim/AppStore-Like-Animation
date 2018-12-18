//
//  ExpandableCell.swift
//  TestAppStoreAnimation
//
//  Created by Ryan Salim on 12/12/18.
//  Copyright © 2018 Ryan Salim. All rights reserved.
//

import UIKit

class ExpandableCell: UICollectionViewCell {

    @IBOutlet weak var viewcontainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var initialFrame: CGRect? = nil
    var initialCornerRadius: CGFloat? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    private func setupCell() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
    }
    
    func expand(in collectionView: UICollectionView) {
        initialFrame = self.frame
        initialCornerRadius = self.contentView.layer.cornerRadius
        
        self.contentView.layer.cornerRadius = 0
        self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        
        layoutIfNeeded()
    }
    
    func collapse() {
        guard let initialFrame = self.initialFrame, let initialCornerRadius = self.initialCornerRadius else {
            return
        }
        
        self.frame = initialFrame
        self.contentView.layer.cornerRadius = initialCornerRadius
        
        self.initialFrame = nil
        self.initialCornerRadius = nil
        
        layoutIfNeeded()
    }
    
    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
        initialFrame = self.frame
        
        let currentY = self.frame.origin.y
        let newY: CGFloat
        
        if currentY < frameOfSelectedCell.origin.y {
            let offset = frameOfSelectedCell.origin.y - currentY
            newY = collectionView.contentOffset.y - offset
        } else {
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        
        self.frame.origin.y = newY
        
        layoutIfNeeded()
    }
    
    func show() {
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        
        layoutIfNeeded()
    }
}
