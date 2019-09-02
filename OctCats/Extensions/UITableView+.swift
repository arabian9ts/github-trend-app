//
//  UITableView+.swift
//  OctCats
//
//  Created by arabian9ts on 2019/09/01.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit

public extension UITableView {
    func register(cellType: UITableViewCell.Type, _ bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register(cellTypes: [UITableViewCell.Type], _ bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
