//
//  TrendPageViewController.swift
//  OctCats
//
//  Created by arabian9ts on 2019/09/12.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit

class TrendPageViewController: UIPageViewController {
    private let langList: [String] = {
        return ["go", "ruby", "swift", "python", "javascript"]
    }()
    
    private let langIcons: [String: UIImage] = {
        return [
            "go": Asset.go.image,
            "ruby": Asset.ruby.image,
            "swift": Asset.swift.image,
            "python": Asset.python.image,
            "javascript": Asset.js.image,
        ]
    }()
    
    private var arrangedSubviews = [UIImageView]()
    
    private var viewCtrls = [UIViewController]()
    private var currentIdx = -1
    
    private var langIconContainerView: UIView = {
        let container = UIView()
        return container
    }()
    
    private var langIconView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()

    private let feedbackGenerator: UIImpactFeedbackGenerator? = {
        if #available(iOS 10.0, *) {
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewCtrls()
        setupLangIconView()
    }
    
    @objc private func longPressGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureStarted()
        }
        else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
        else if gesture.state == .ended {
            handleGestureEnded()
        }
    }
    
    private func handleGestureStarted() {
        UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
            self.langIconView.alpha = 1
            self.langIconView.isHidden = false
        }, completion: nil)
    }
    
    private func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: langIconView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: langIconView.frame.height / 2)
        let hitTestView = langIconContainerView.hitTest(fixedYLocation, with: nil)
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseOut, animations: {
                self.langIconView.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -40)
                let imageView = hitTestView as! UIImageView
                let index = self.arrangedSubviews.firstIndex(of: imageView)
                self.move(to: index!)
            }, completion: nil)
        }
    }
    
    private func handleGestureEnded() {
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseOut, animations: {
            let stackView = self.langIconView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            self.langIconView.transform = CGAffineTransform(translationX: 0, y: 10)
            self.langIconView.alpha = 0
        }, completion: { _ in
            self.langIconView.transform = .identity
            self.langIconView.isHidden = true
            self.langIconView.alpha = 0
        })
    }
    
    private func setupLangIconView() {
        let iconSize = 50
        let spacing: CGFloat = 8
        
        view.addSubview(langIconContainerView)
        langIconContainerView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-iconSize)
            make.width.equalTo(iconSize * langList.count + (langList.count - 1) * Int(spacing))
            make.height.equalTo(iconSize)
        }
        
        arrangedSubviews = langList.map({ (lang) -> UIImageView in
            let image = langIcons[lang]
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        langIconView = UIStackView(arrangedSubviews: arrangedSubviews)
        langIconView.spacing = spacing
        langIconView.axis = .horizontal
        langIconView.distribution = .fillEqually
        langIconView.isLayoutMarginsRelativeArrangement = true
        langIconContainerView.addSubview(langIconView)
        langIconView.snp.makeConstraints { (make) -> Void in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        langIconContainerView.addGestureRecognizer(tapGesture)
        
        langIconContainerView.backgroundColor = .clear
        langIconView.backgroundColor = .clear
        
        langIconView.isHidden = true
    }
    
    private func setupViewCtrls() {
        langList.forEach({ _ in
            viewCtrls.append(TrendViewController())
            setViewControllers([viewCtrls.last!], direction: .forward, animated: false, completion: nil)
        })
        move(to: 0)
    }
    
    private func move(to: Int) {
        if currentIdx != to {
            let lang = langList[to]
            Dispatcher.shared.dispatch(TrendAction.purgeTrends)
            Dispatcher.shared.dispatch(TrendAction.getTrends(lang: lang))
            if let generator = self.feedbackGenerator {
                generator.impactOccurred()
            }
            currentIdx = to
            setViewControllers([viewCtrls[to]], direction: .forward, animated: false, completion: nil)
        }
    }
}
