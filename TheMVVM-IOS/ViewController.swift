//
//  ViewController.swift
//  TheMVVM-IOS
//
//  Created by fee
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UINavigationController {
    private lazy var mDispose = DisposeBag.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testBtn = UIButton.init()
        testBtn.setTitle("测试", for: UIControl.State.normal)
        testBtn.backgroundColor = .gray
        testBtn.setTitleColor(.red, for: .normal)
        self.view.addSubview(testBtn) { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        testBtn.rx.tap.subscribe { [weak self] Void in
            let webUrl = "http://www.zgjfzgl.com/"
            let webviewVC = CommonWebviewVCViewController()
            webviewVC.curWebHostUrl = webUrl
//            self?.navigationController?.pushViewController(CommonWebviewVCViewController(), animated: true)
            self?.pushViewController(webviewVC, animated: true)
        } onError: { Error in
            
        }
        .disposed(by: mDispose)

    }


}

