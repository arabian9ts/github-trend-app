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

let REUSE_IDEF = "TrendTableViewCell"

class ViewController: UIViewController {
    
    private var trendTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: REUSE_IDEF)
        return tableView
    }()
    
    let dataSource = TrendDataSource()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrendView()
        
//        let label = CounterLabel()
//        label.frame = view.frame
//        label.center = view.center
//        view.addSubview(label)
//        label.startCount(from: 0, to: 100)
        
//        GitHubTrendAPI.shared.request(GitHubTrendRequest.GetTrend(lang: "Swift"))
//        .subscribe(onSuccess: { (trends) in
//            dump(trends)
//        }, onError: { (err) in
//            print("error: \(err)")
//        })
//        .disposed(by: disposeBag)
    }
    
    private func setupTrendView() {
        trendTableView.dataSource = dataSource
        
        view.addSubview(trendTableView)
        
        trendTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trendTableView.topAnchor.constraint(equalTo: view.topAnchor),
            trendTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trendTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trendTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDEF, for: indexPath) as! TrendTableViewCell
        return cell
    }
    
}

