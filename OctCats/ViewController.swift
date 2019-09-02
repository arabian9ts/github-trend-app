//
//  ViewController.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import SkeletonView

fileprivate let reuseIdef = "TrendTableViewCell"

class ViewController: UIViewController {
    
    private var trendTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.register(cellType: TrendTableViewCell.self)
        return tableView
    }()
    
    private let dataSource = {
        return TrendDataSource()
    }()
    
    private let disposeBag = {
        return DisposeBag()
    }()
    
    private let store: TrendStore = {
        return TrendStore()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrendView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Dispatcher.shared.dispatch(TrendAction.getTrends(lang: "Swift"))
    }
    
    private func setupTrendView() {
        trendTableView.delegate = dataSource
        view.addSubview(trendTableView)
        trendTableView.translatesAutoresizingMaskIntoConstraints = false
        trendTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view)
        }
        
        store.trendRepositories.bind(to: trendTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}

class TrendDataSource: NSObject, UITableViewDelegate, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [GitHubRepository]
    private var itemModels: [GitHubRepository] = []
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<[GitHubRepository]>) {
        Binder(self) { dataSource, element in
            dataSource.itemModels = element
            tableView.reloadData()
            }
            .on(observedEvent)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TrendTableViewCell.self, for: indexPath)
//        cell.isSkeletonable = true
//        cell.showGradientSkeleton()
        cell.setupCell(model: itemModels[indexPath.row])
        return cell
    }
    
    func tablew(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
