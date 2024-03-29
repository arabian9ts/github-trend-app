//
//  TrendViewController.swift
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

fileprivate let reuseIdef = "TrendTableViewCell"

class TrendViewController: UIViewController {
    
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
        return TrendStore.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupTrendView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trendTableView.indexPathsForSelectedRows?.forEach {
            trendTableView.deselectRow(at: $0, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        let colors = [#colorLiteral(red: 0.2132213717, green: 0.3168508858, blue: 0.640188769, alpha: 1).cgColor, #colorLiteral(red: 0.2537953442, green: 0.1709154244, blue: 0.5889911168, alpha: 1).cgColor, #colorLiteral(red: 0.5882814194, green: 0.2829623238, blue: 0.6070748731, alpha: 1).cgColor]
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = colors
        view.layer.addSublayer(gradientLayer)
    }
    
    private func setupTrendView() {
        trendTableView.delegate = dataSource
        trendTableView.backgroundColor = .clear
        view.addSubview(trendTableView)
        trendTableView.translatesAutoresizingMaskIntoConstraints = false
        trendTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view)
        }
        
        store.trendRepositories.asObservable().bind(to: trendTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        dataSource.selectedCellSubject
            .map{ "\($0.author!)/\($0.name!)" }
            .subscribe(onNext: { repositoryTitle in
                let repositoryURL = "https://github.com/\(repositoryTitle)"
                let vc = WebViewController()
                let _ = vc.loadWebView(input: WebViewController.Input(urlString: repositoryURL, title: repositoryTitle))
                let navigationVC = GitHubRepositoryViewController(rootViewController: vc)
                self.present(navigationVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

class TrendDataSource: NSObject, UITableViewDelegate, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [GitHubRepository]
    private var itemModels: [GitHubRepository] = []
    fileprivate let selectedCellSubject = PublishSubject<GitHubRepository>()
    
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
        if itemModels.count == 0 {
            return 10
        }
        return itemModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TrendTableViewCell.self, for: indexPath)
        if itemModels.count == 0 {
            cell.showMask()
        }
        else {
            cell.setupCell(model: itemModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = itemModels[indexPath.row]
        selectedCellSubject.onNext(repository)
    }
}
