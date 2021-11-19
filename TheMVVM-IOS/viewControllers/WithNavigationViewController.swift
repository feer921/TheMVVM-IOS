//
//  WithNavigationViewController.swift
//  TheMVVM-IOS
//
//  Created by fee
//

import UIKit

class WithNavigationViewController: BaseViewController {

    /// 显示或者隐藏 系统自带的 导航栏 [navigationItem]
    func showOrHideNavigationBar(isToShowOrHide: Bool = true) {
        navigationController?.setNavigationBarHidden(!isToShowOrHide, animated: true)
    }
    
    /// 便捷的 给 系统自带的 头部导航栏添加 【UIBarButtonItem】
    func addRightBarButtonItems(aRightBarItem: UIBarButtonItem,isToAppendOrReplaceExists: Bool = true, isNeedAnim: Bool = true) {
        if navigationController == nil { //如果当前 VC 并不在 有导航栏的控制器 上下文中，则下面的无意义
            return
        }
        navigationItem.addRightBarButtonItems(aRightBarItem: aRightBarItem, isToAppendOrReplaceExists: isToAppendOrReplaceExists, isNeedAnim: isNeedAnim)
    }
    
    func addLeftBarButtonItems(aLeftBarItem: UIBarButtonItem, isToAppendOrReplaceExists: Bool = true, isNeedAnim: Bool = true) {
        if navigationController == nil { //如果当前 VC 并不在 有导航栏的控制器 上下文中，则下面的无意义
            return
        }
        navigationItem.addLeftBarButtonItems(aLeftBarItem: aLeftBarItem, isToAppendOrReplaceExists: isToAppendOrReplaceExists, isNeedAnim: isNeedAnim)
    }
    
    
    /// 给系统自带的 导航栏设置 中间的标题
    /// - Parameter theTitleText: 标题文本
    func setCenterTitleOfNavigation(theTitleText: String?) {
        navigationItem.title = theTitleText
    }
}


/// 对 【UINavigationItem】的扩展：便捷添加 bar button items
/// 注意一点：属性：[leftBarButtonItem] 即是最左侧的 bar item； 属性： [rightBarButtonItem] 即为 最右侧 的 bar item
extension UINavigationItem {
    
    func addRightBarButtonItems(aRightBarItem: UIBarButtonItem, isToAppendOrReplaceExists: Bool = true, isNeedAnim: Bool = true) {
        if !isToAppendOrReplaceExists {// 不是以 追加的 形式显示，则直接赋值或者 替换 原来的 右侧 button
            //如果之前 有 [rightBarButtonItems] 是否要清除？？？从方法功能上来讲是需要把之前的全清除
            setRightBarButtonItems(nil, animated: false)// 先清除一次可能已经存在的 [rightBarButtonItems]
            setRightBarButton(aRightBarItem, animated: isNeedAnim) //如果之前已经有 items，不作处理的情况下，会替换掉第一个添加进来的
            //如果之前 有 [rightBarButtonItems] 是否要清除？？？从方法功能上来讲是需要把之前的全清除
//            setRightBarButtonItems(nil, animated: isNeedAnim) //放在后面不起作用
        } else {//追加到右侧 items 左侧? 的形式去显示
            appendRightBarItems(aRightBarItem: aRightBarItem, isNeedAnim: isNeedAnim)
        }
    }
    /// 追加 右侧 UIBarButtonItem
    func appendRightBarItems(aRightBarItem: UIBarButtonItem, isNeedAnim: Bool = true) {
        if rightBarButtonItems != nil {// 已经存在了 rightBarItems,则追加，在最左侧
            rightBarButtonItems?.append(aRightBarItem)
        } else {
            setRightBarButtonItems([aRightBarItem], animated: isNeedAnim)
            //同样的，如果原来 指定了 单独的一个 rightBarButtonItem 是否要清除？？[验证了可以不清除]
        }
    }
    /// 添加或者 追加 左侧的 bar item
    func addLeftBarButtonItems(aLeftBarItem: UIBarButtonItem, isToAppendOrReplaceExists: Bool = true, isNeedAnim: Bool = true) {
        if !isToAppendOrReplaceExists {// 不是以 追加的 形式显示，则直接赋值或者 替换 原来的 左侧 button
        ////如果之前 有 [leftBarButtonItems] 是否要清除？？？: 从方法功能上来讲是需要把之前的全清除
            setLeftBarButton(nil, animated: isNeedAnim)
            leftBarButtonItem = nil
            setLeftBarButtonItems(nil, animated: isNeedAnim)
            rightBarButtonItems = nil
            leftBarButtonItem = aLeftBarItem //左侧的使用这个直接赋值才有效(能把之前添加的给替换掉)
            setLeftBarButton(aLeftBarItem, animated: isNeedAnim) //如果之前已经有 items，不作处理的情况下，会替换掉第一个添加进来的
        } else {//追加到左侧 items 左侧? 的形式去显示
            appendLeftBarItems(aLeftBarItem: aLeftBarItem, isNeedAnim: isNeedAnim)
        }
    }
    
    /// 追加 左侧 UIBarButtonItem
    func appendLeftBarItems(aLeftBarItem: UIBarButtonItem, isNeedAnim: Bool = true) {
        if leftBarButtonItems != nil {// 已经存在了 leftBarItems,则追加，在最右侧
            leftBarButtonItems?.append(aLeftBarItem)
        } else {// 之前 并不存在 leftBarButtonItems
            setLeftBarButtonItems([aLeftBarItem], animated: isNeedAnim)
            //同样的，如果原来 指定了 单独的一个 leftBarButtonItem 是否要清除？？[验证了可以不清除]
        }
    }
    /// 设置 导航栏 中间的标题?
    func setCenterTitle(_ centerTitle: String?){
        title = centerTitle
    }
}
