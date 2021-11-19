//
//  CommonWebviewVCViewController.swift
//  TheMVVM-IOS
//
//  Created by fee
//

import UIKit
import WebKit
import RxSwift
import SwiftUI
class CommonWebviewVCViewController: WithNavigationViewController {
    
    var mWebview: WKWebView!
    /// 当前 WebView 加载的 网页的 主 url
    var curWebHostUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //和当前 VC 同宽、高
        mWebview = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let _ = loadUrl(theWebviewUrl: curWebHostUrl)
        self.view.addSubview(mWebview)
        let refreshBarItem = UIBarButtonItem.init(systemItem: UIBarButtonItem.SystemItem.refresh, primaryAction: nil, menu: nil)
        refreshBarItem.rx.tap.subscribe(onNext: {[weak self] Void in
           let _ = self?.reload()
        }, onError: { Error in
            
        }).disposed(by: mDispose)
        let closeBarItem = UIBarButtonItem.init(systemItem: UIBarButtonItem.SystemItem.close, primaryAction: nil, menu: nil)
        addRightBarButtonItems(aRightBarItem: closeBarItem)
        addRightBarButtonItems(aRightBarItem: refreshBarItem)
        
    }
    
    //MARK: 给定 对应的 网页地址，进行加载
    func loadUrl(theWebviewUrl: String?) -> WKNavigation? {
        if theWebviewUrl?.isEmpty ?? true {
            return nil
        }
        guard let theUrl = URL.init(string: theWebviewUrl!) else {
            return nil
        }
        if curWebHostUrl.isEmpty {
            curWebHostUrl = theWebviewUrl!
        }
        return mWebview.load(URLRequest.init(url: theUrl))
    }
    
    //MARK: 重新加载 整个网页
    func reload(isReloadFromOrigin: Bool = false) -> WKNavigation?  {
        if isReloadFromOrigin {
            return mWebview.reloadFromOrigin()
        }
        //        mWebview.reloadInputViews() //?? 这个是何意？？
        return mWebview.reload()
    }
    
    //MARK: 判断当前是否正在 加载网页
    func isLoading() -> Bool {
        return mWebview.isLoading
    }
    
    //MARK: 停止 当前的正在加载网页
    func stopLoading()  {
        if isLoading() {
            mWebview.stopLoading()
        }
    }
    
    
}
