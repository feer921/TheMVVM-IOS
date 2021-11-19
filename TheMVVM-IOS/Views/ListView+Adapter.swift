//
//  ListView+Adapter.swift
//
//
//  Created by fee
//

import Foundation
import UIKit
/**
 通用 的 数据适配器
 */
open class BaseDataSourceAdapter<DATA>: NSObject{
    /**
     当前数据源是否 为单 section 的列表模式
     def = true
     */
    var isJustOneSectionList = true
    /**
     当前 的数据集
     */
    var datas: [DATA]?
    {
        didSet{
            notifyDataSetChanged()
        }
    }
    var sectionDatas: [Int: [DATA]]?
    
    
    func getItemCount(ofSection sectionAt: Int) -> Int {
        if(isJustOneSectionList){
            return datas?.count ?? 0
        }
        return sectionDatas?[sectionAt]?.count ?? 0
    }
    /**
     获取 列表中当前 有多少个 分组/分区
     def = 1；一般情况下 为只需要 1 个 section; ,
     
     */
    func getSectionCount() -> Int {
        if(isJustOneSectionList){
            return 1
        }
        return sectionDatas?.count ?? 1
    }
    /**
     获取 整个数据集的 数量
     */
    func getTotalDataCount() -> Int {
        if(isJustOneSectionList){
            return getItemCount(ofSection: 0)
        }
        guard let sectionDatas = sectionDatas else {
            return 0
        }
        var totalCount = 0
        for value in sectionDatas.values{
            totalCount += value.count
        }
        return totalCount
    }
    
    /**
     根据 [IndexPath] 获取出 当前渲染的 Cell对应 的 DATA
     */
    func getData(indexPath: IndexPath) -> DATA? {
        let sectionOfData = indexPath.section
        let itemIndex = indexPath.item
        if(isJustOneSectionList && datas != nil){
            return datas?[itemIndex]
        }
        let dataListInSection = self.sectionDatas?[sectionOfData]
        guard let dataList = dataListInSection else {
            return nil
        }
        return dataList[itemIndex]
    }
    
    //MARK: 通知 列表 数据更改了
    /**
     通知列表 数据更改了
     */
    func notifyDataSetChanged()  {
        
    }
    
    //MARK: 通知 某些个 items 数据发生了更改
    func notifyItemChanged(at itemIndexes: IndexPath...) {
    }
    
    /**
     向列表中添加 一个 数据，并且默认情况下会自动 刷新列表
     */
    func addData(aData: DATA,_ isNeedAutoRefresh: Bool = true) {
        if(datas == nil){
            datas = [DATA]()
        }
        datas?.append(aData)
        if isNeedAutoRefresh{
            notifyDataSetChanged()
        }
    }
    
    /**
     移除 某个 位置的 数据,并自动刷新列表
     */
    func removeItem(at indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let itemIndex = indexPath.item
        //TODO: 需要校验 将移除的位置 与现在数据集的位置是否安全？
        if(isJustOneSectionList){
            guard var dataList = datas else {
                return
            }
            dataList.remove(at: itemIndex)
        }
        if(sectionDatas != nil){
            var dataList = sectionDatas?[sectionIndex]
            if(dataList != nil){
                dataList?.remove(at: itemIndex)
            }
        }
        notifyDataSetChanged()
    }
    
    func clearDatas()  {
        datas = nil
        //        sectionDatas?.removeAll()
        sectionDatas = nil
        notifyDataSetChanged()
    }
    //MARK: 获取当前所有的 数据(集)，注意如果当前列表 为分组数据则会平展为 一维数据集
    func getAllDatas() -> [DATA]? {
        if isJustOneSectionList{
            return datas
        }
        guard let sectionMapDatas = sectionDatas else {
            return nil
        }
        var allDatas = [DATA]()
        for value in sectionMapDatas.values{
            allDatas += value
        }
        return allDatas
    }
}

/**
 专门用于 [UICollectionView] 给设置 数据源的  适配器
 */
class BaseCollectionViewDataSourceAdater<DATA> : BaseDataSourceAdapter<DATA>,UICollectionViewDataSource{
    weak var curCollectionView: UICollectionView?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curDataAtIndexPath = getData(indexPath: indexPath)
        return onBindCell(curItemData: curDataAtIndexPath, cellForItemAt: indexPath)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return getItemCount(ofSection: section)
    }
    
    /**
     获取 当前 列表 有多少 个 section
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return getSectionCount()
    }
    
    
    /**
     渲染当前  Cell时，进行 与数据的绑定
     //子类 实现这个方法就行
     -- return UICollectionViewCell
     */
    func onBindCell(curItemData: DATA?, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // here do nothing other, let subclass implement
        return UICollectionViewCell.init()
    }
    
    //MARK: 通知 列表 数据更改了
    /**
     通知列表 数据更改了
     */
    override func notifyDataSetChanged()  {
        curCollectionView?.reloadData()
    }
    
    //MARK: 通知 某些个 items 数据发生了更改
    override func notifyItemChanged(at itemIndexes: IndexPath...) {
        curCollectionView?.reloadItems(at: itemIndexes)
    }
    
    
    
}

extension UICollectionView{
    func setAdapter<DATA>(dataSourceAdapter: BaseCollectionViewDataSourceAdater<DATA>)  {
        self.dataSource = dataSourceAdapter
        dataSourceAdapter.curCollectionView = self
    }
}

/**
 可以选择的 适配器
 [SK] 为 数据集中的元素 的某个属性可以作为、代表 被选中的惟一标识
 */
class ASelectableAdapter<DATA,SK: Hashable> : BaseCollectionViewDataSourceAdater<DATA> {
    /**
     用于 相识 列表数据 被选中的唯一标识
     */
    var theSelectedUniqueMarks: Set<SK>? = nil
    
    /**
     当前 适配器 的 模式：
     def = normal
     */
    var curAdapterMode: AdapteMode = .normal
    {
        willSet{
            let newMode = newValue
            if(newMode != curAdapterMode){
                notifyDataSetChanged()
            }
        }
    }
    
    enum AdapteMode{
        /**
         正常模式
         */
        case normal
        /**
         单选 模式
         */
        case single_choice
        /**
         多选模式
         */
        case multy_choice
    }
    
    /**
     当前 适配器 是否处于 选择模式 场景
     */
    func isInSelectMode() -> Bool {
        return curAdapterMode != .normal
    }
    
    /**
     子类 需要重写 本方法，来提供 当前数据集的 元素 数据 作为 选中的 惟一标识
     */
    //MARK: 有选择模式的 适配器 需要 重写实现本方法
    open func toJudgeItemDataUniqueMark(theItemData: DATA?) -> SK?{
        
        return nil
    }
    /**
     当 列表中的 item 被用户所 单击时的 通用 处理，会自动 处理单选或多选的功能 逻辑
     */
    func theItemClicked(itemIndexPath: IndexPath) -> Bool {
        if(curAdapterMode == .normal){
            return false
        }
        //单选或者 多选
        var isSelected = false
        let theUniqueMarkOfData = toJudgeItemDataUniqueMark(theItemData: getData(indexPath: itemIndexPath))
        if(theUniqueMarkOfData == nil){
            return false
        }
        var isAlreadyAdded = false
        if(theSelectedUniqueMarks == nil){
            theSelectedUniqueMarks = Set<SK>()
        }else{
            isAlreadyAdded = theSelectedUniqueMarks!.contains(theUniqueMarkOfData!)
            if(curAdapterMode == .single_choice){//如果是单选模式
                if isAlreadyAdded{ //如果单选模式下，并且 当前 [DATA] 已经被选中了，则直接返回表示 已经选中添加了
                    return true
                }
                //单选模式下，要先清空 选中标记
                theSelectedUniqueMarks?.removeAll()
            }
        }
        if(curAdapterMode == .single_choice){//单选模式时，则直接把当前的 [DATA]添加
            theSelectedUniqueMarks?.insert(theUniqueMarkOfData!)
            isSelected = true
            notifyDataSetChanged()//单选模式下需要 全局刷新
        }else{//多选模式下
            isSelected = !isAlreadyAdded //如果之前已经选中，则变成 不选中，如果之前未选中添加，则选中添加
            if(isSelected){
                theSelectedUniqueMarks?.insert(theUniqueMarkOfData!)
            }else{
                theSelectedUniqueMarks?.remove(theUniqueMarkOfData!)
            }
            notifyItemChanged(at: itemIndexPath)
        }
        return isSelected
    }
    
    //MARK: 便捷的 让列表 全选 或者 全不选
    func selectAllOrCancelAll(isToSelectAllOrNot: Bool) {
        if(curAdapterMode != .multy_choice){
            return
        }
        var isEffected = false
        if(isToSelectAllOrNot){//要全选
            if(nil == theSelectedUniqueMarks){
                theSelectedUniqueMarks = Set<SK>()
            }
            if let allDatas = getAllDatas(){
                for itemData in allDatas {
                    if let uniqueMark = toJudgeItemDataUniqueMark(theItemData: itemData){
                        theSelectedUniqueMarks?.insert(uniqueMark)
                        isEffected = true
                    }
                }
            }
        }else{
            if(theSelectedUniqueMarks != nil && theSelectedUniqueMarks?.isEmpty == false){
                theSelectedUniqueMarks?.removeAll()
                isEffected = true
            }
        }
        if(isEffected){
            notifyDataSetChanged()
        }
    }
    //MARK: 用来判断 当前 的数据 是否是被选中的
    func isTheItemSelected(theItemData: DATA?) -> Bool {
        guard let item = theItemData else {
            return false
        }
        if let dataMark = toJudgeItemDataUniqueMark(theItemData: item){
            return theSelectedUniqueMarks?.contains(dataMark) ?? false
        }
        return false
    }
    
    //MARK: 检出当前 列表中 所有被选中的 数据
    func pickOutSelectedDatas() -> [DATA]? {
        var resultDatas: [DATA]? = nil
        if let selectedMarks = theSelectedUniqueMarks{
            if let allDatas = getAllDatas(){
                resultDatas = allDatas.filter { item in
                    if let dataMark = toJudgeItemDataUniqueMark(theItemData: item){
                        return selectedMarks.contains(dataMark)
                    }
                    return false
                }
            }
        }
        return resultDatas
    }
}

protocol UICollectionViewItemClickListener{
    associatedtype DATA
    
    /**
     列表中  item 的点击事件
     */
    func onItemClick(theAdapter: BaseCollectionViewDataSourceAdater<DATA>, itemIndexPath: IndexPath)
    
    /**
     列表中 item 内的
     */
    func onItemChildClick(theAdapter: BaseCollectionViewDataSourceAdater<DATA>,theChildView: UIView,itemIndexPath: IndexPath)
}

