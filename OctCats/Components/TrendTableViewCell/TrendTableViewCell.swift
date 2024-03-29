//
//  TrendTableViewCell.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/30.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit
import SkeletonView

class TrendTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var langColorView: UIView!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var starLabel: CounterLabel!
    @IBOutlet weak var forkLabel: CounterLabel!
    @IBOutlet weak var todaysStarLabel: CounterLabel!
    @IBOutlet weak var langColorAsideView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set (newFrame) {
            let size = newFrame.size
            let newWidth = size.width * 0.9
            let newHeight = size.height * 0.9
            let marginSizeX = (size.width - newWidth) / 2
            let marginSizeY = (size.height - newHeight) / 2
            super.frame = CGRect(x: marginSizeX, y: newFrame.minY + marginSizeY, width: newWidth, height: newHeight)
        }
    }
    
    private func setupLayout() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }
    
    func showMask() {
        repositoryNameLabel.sizeToFit()
        descLabel.sizeToFit()
        repositoryNameLabel.showAnimatedGradientSkeleton()
        descLabel.showAnimatedGradientSkeleton()
        langLabel.showAnimatedGradientSkeleton()
        starLabel.showAnimatedGradientSkeleton()
        forkLabel.showAnimatedGradientSkeleton()
    }
    
    func hideMask() {
        repositoryNameLabel.hideSkeleton()
        descLabel.hideSkeleton()
        langLabel.hideSkeleton()
        starLabel.hideSkeleton()
        forkLabel.hideSkeleton()
    }
    
    func setupCell(model: GitHubRepository) {
        hideMask()
        repositoryNameLabel.text = "\(model.author!) / \(model.name!)"
        langColorView.backgroundColor = UIColor(hex: model.languageColor ?? "", alpha: 1)
        langColorAsideView.backgroundColor = UIColor(hex: model.languageColor ?? "", alpha: 1)
        langLabel.text = model.language
        descLabel.text = model.description
        
        let stars = model.stars ?? 0
        let forks = model.forks ?? 0
        starLabel.startCount(from: 0, to: Double(stars))
        forkLabel.startCount(from: 0, to: Double(forks))
    }
}
