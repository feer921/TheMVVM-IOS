//
//  BaseViewController.swift
//  TheMVVM-IOS
//
//  Created by fee
//

import UIKit
import RxSwift

/**
 VC 的基类
 */
class BaseViewController: UIViewController {
    /// 对 Rx 的 资源回收对象
    lazy var mDispose = DisposeBag.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        initViewModels()
        initDatas()
    }
    
    
    
    
    /// 子类 在这个方法里 初始化 视图
    func initViews() {
        
    }
    
    /// 子类在这个方法里初始化 [ViewModels]
    func initViewModels() {
        
    }
    
    /// 子类在这个方法里 开始加载数据
    func initDatas() {
        
    }
}
