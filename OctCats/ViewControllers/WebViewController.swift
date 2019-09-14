//
//  WebViewController.swift
//  OctCats
//
//  Created by arabian9ts on 2019/09/14.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit

class WebViewController: UIViewController {
    struct Input {
        private(set) var urlString: String
        private(set) var title: String
        
        init(urlString: String, title: String) {
            self.urlString = urlString
            self.title = title
        }
    }
    
    struct Output {}

    private let disposeBag = DisposeBag()
    private let webview = WKWebView()
    private let progressBar = UIProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "close",
            style: .done,
            target: self,
            action: #selector(backToPreviousView))
    }
    
    private func setupWebView() {
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.height.equalTo(3)
        }
        
        let loadingObservable = webview.rx.observe(Bool.self, "loading").share()

        loadingObservable
            .filter{ $0 != nil }
            .map{ !$0! }
            .observeOn(MainScheduler.instance)
            .bind(to: progressBar.rx.isHidden)
            .disposed(by: disposeBag)
        
        loadingObservable
            .filter{ $0 != nil }
            .map{ $0! }
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        loadingObservable
            .map { [weak self] _ in return self?.webview.title }
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        webview.rx.observe(Double.self, "estimatedProgress")
            .filter{ $0 != nil }
            .map{ Float($0!) }
            .observeOn(MainScheduler.instance)
            .bind(to: progressBar.rx.progress)
            .disposed(by: disposeBag)
    }
    
    func loadWebView(input: Input) -> Output {
        if let url = URL(string: input.urlString) {
            webview.load(URLRequest(url: url))
        }
        title = input.title
        navigationItem.title = input.title
        return Output()
    }
    
    @objc private func backToPreviousView() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
