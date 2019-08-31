//
//  Dispatcher.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/31.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import RxSwift

final class Dispatcher {
    static let shared = Dispatcher()
    private let dispatcher = PublishSubject<Action>()
    
    func dispatch(_ action: Action) {
        dispatcher.onNext(action)
    }
    
    func register<A: Action>(actionHandler: @escaping (_ action: A) -> Void) -> Disposable {
        return dispatcher.subscribe(onNext: { action in
            guard let a = action as? A else { return }
            actionHandler(a)
        })
    }
}
