//
//  UIView+.swift
//  TheMVVM-IOS
//
//  Created by fee
//

import UIKit
import SnapKit

extension UIView {
    /**
      给 UIView 扩展的 便捷的添加到其他的父 视图中的方法,并且可以直接追加 布局配置代码块
     */
    func addTo(parentView: UIView?,_ makeClouse: ((_ make: ConstraintMaker) -> Void)? = nil) {
        guard let containerView = parentView else {
            return
        }
        containerView.addSubview(self)
        guard let makeBlock = makeClouse else {
            return
        }
        self.snp.makeConstraints { make in
            makeBlock(make)
        }
    }
    /// 当前 UIView 添加 子 View
    func addSubview(_ theView: UIView?,_ makeClouse: ((_ make: ConstraintMaker) -> Void)? = nil){
        guard let subView = theView else{
            return
        }
        addSubview(subView)
        guard let makeBlock = makeClouse else {
            return
        }
        subView.snp.makeConstraints { make in
            makeBlock(make)
        }
    }
}
