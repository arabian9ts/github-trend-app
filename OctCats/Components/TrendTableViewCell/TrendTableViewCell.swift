//
//  TrendTableViewCell.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/30.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit

class TrendTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var langColorView: UIView!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var starLabel: CounterLabel!
    @IBOutlet weak var forkLabel: CounterLabel!
    @IBOutlet weak var todaysStarLabel: CounterLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        sizeToFit()
        selectionStyle = .none
        layer.cornerRadius = 15.0
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        UserDefaults.standard.set(false, forKey: "UIConstarintBasedLayoutLogUnsatisfiable")
    }
    
    func setupCell(model: GitHubRepository) {
        langLabel.text = "Swift"
        descLabel.text = "Feed reader for macOS "
        starLabel.startCount(from: 0, to: 100)
        forkLabel.startCount(from: 0, to: 50)
    }
}
