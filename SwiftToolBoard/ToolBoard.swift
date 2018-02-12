//
//  ToolBoard.swift
//  SwiftToolBoard
//
//  Created by MacPeal on 29/01/2018.
//  Copyright © 2018 MacPeal. All rights reserved.
//

import UIKit

@objc public protocol ToolBoardDelegate: class{
    func toolBoard(_ toolBoard: ToolBoard, didSelectObject index: Int)
    func toolBoard(_ toolBoard: ToolBoard, cellForItem cell : UICollectionViewCell, indexPath: IndexPath)
}

public enum Direction{
    case top
    case bottom
    case left
    case right
}

open class ToolBoard: UIView {
    
    var view: UIView!
    open weak var delegate: ToolBoardDelegate?
    private var itemNumber : Int = 0
    private var cellNibName: String = "ToolBoardCell"
    private var reuseCellIdentifier: String = "defaultCell"
    
    private var cellWidth : CGFloat = 80.0
    private var cellHeight : CGFloat = 50.0
    
    
    
    private var cellSpacingTop : CGFloat = 10.0
    private var cellSpacingBottom : CGFloat = 10.0
    private var cellSpacingLeft : CGFloat = 10.0
    private var cellSpacingRight : CGFloat = 10.0
    
    private var collectionWith : CGFloat = UIScreen.main.bounds.width
    private var collectionHeight : CGFloat = 70.0
    
    private var minimumSpaceBeetweenCell : CGFloat = 10.0
    
    private var defaultBackgroundColor : UIColor = UIColor.lightGray
    private var defaultColor : UIColor = UIColor.gray
    private var defaultRadius : CGFloat = 0
    
    
    private var initView : ToolBoard? = nil
    
    private var colorTab : [UIColor] = []
    private var radiusTab : [CGFloat] = []
    
    
    private var isPersonalizedCell : Bool = false

    private var bundle : Bundle = Bundle()
    
    @IBOutlet weak var toolBoardCollectionView: UICollectionView!
    
    
    public init(){
        super.init( frame: CGRect(x: 0, y:0, width:UIScreen.main.bounds.width, height: self.collectionHeight))
        
        for _ in 0..<self.itemNumber{
            colorTab.append(self.defaultColor)
            radiusTab.append(self.defaultRadius)
        }
        
        self.bundle = Bundle(for: type(of: self))
        loadXib()
    }
    
    public init(itemNumber : Int){
        super.init( frame: CGRect(x: 0, y:0, width:UIScreen.main.bounds.width, height: self.collectionHeight))
        
        self.itemNumber = itemNumber
        for _ in 0..<self.itemNumber{
            colorTab.append(self.defaultColor)
            radiusTab.append(self.defaultRadius)
            
        }
        
        self.bundle = Bundle(for: type(of: self))
        loadXib()
    }
    
    public init(itemNumber : Int, cellNibName : String, reuseCellIdentifier : String, bundle : Bundle){
        super.init( frame: CGRect(x: 0, y:0, width:UIScreen.main.bounds.width, height: self.collectionHeight))
        self.isPersonalizedCell = true
        self.itemNumber = itemNumber
        
        self.cellNibName = cellNibName
        self.reuseCellIdentifier = reuseCellIdentifier
        
        for _ in 0..<self.itemNumber{
            colorTab.append(self.defaultColor)
            radiusTab.append(self.defaultRadius)
            
        }
        self.bundle = bundle
        loadXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    fileprivate func loadXib(){
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight]
        view.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.collectionHeight)
        addSubview(view)
        self.refresh()
    }
    
    override open func awakeFromNib() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.collectionHeight)
    }
    
    
    fileprivate func loadViewFromNib() -> UIView {
        let thisBundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ToolBoard", bundle: thisBundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! ToolBoard
        
        self.initView = view
        return view
    }
    //Refresh Methode
    private func refresh(){
        if let layout = self.initView?.toolBoardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.sectionInset = UIEdgeInsets(top:self.cellSpacingTop, left: self.cellSpacingLeft, bottom:self.cellSpacingBottom, right:self.cellSpacingRight)
            
            let size = CGSize(width: self.cellWidth, height: self.cellHeight)
            layout.itemSize = size
            
            layout.minimumLineSpacing = self.minimumSpaceBeetweenCell
            layout.scrollDirection = .horizontal
            
            self.initView?.toolBoardCollectionView.backgroundColor = self.defaultBackgroundColor
            
            self.initView?.toolBoardCollectionView.collectionViewLayout = layout
        }
    }
    //cancel personalized cell
    public func returnToDefaultItems(){
        self.isPersonalizedCell = false
        self.cellNibName = "toolBoardCell"
        self.reuseCellIdentifier = "simpleCell"
        self.refresh()
        self.initView?.toolBoardCollectionView.reloadData()
    }
    
    
    
    public func changeItemBackgroundColor(at index : Int, color : UIColor){
        
        self.colorTab[index] = color
        self.initView?.toolBoardCollectionView.reloadData()
    }
    
    public func changeBackGroundColor(color : UIColor){
        self.defaultBackgroundColor = color
        self.refresh()
        
    }
    public func changeItemsBackgroundColor(color : UIColor){
        self.defaultColor = color
        for i in 0..<self.colorTab.count{
            colorTab[i] = self.defaultColor
        }
        self.initView?.toolBoardCollectionView.reloadData()
        
    }
    
    public func changeItemRadius(at index : Int, radius : CGFloat){
        self.radiusTab[index] = radius
        self.initView?.toolBoardCollectionView.reloadData()
        
    }
    
    public func changeItemsRadius(radius : CGFloat) {
        self.defaultRadius = radius
        for i in 0..<self.radiusTab.count{
            radiusTab[i] = self.defaultRadius
        }
        self.initView?.toolBoardCollectionView.reloadData()
    }
    
    public func changeItemNumber(number : Int){
        
        var diff = number - self.itemNumber
        
        self.itemNumber = number
        
        if diff < 0{
            diff = diff * -1
            for _ in 0..<diff{
                _ = colorTab.popLast()
                _ = radiusTab.popLast()
                
            }
        } else if diff > 0 {
            for _ in 0..<diff{
                colorTab.append(self.defaultColor)
                radiusTab.append(self.defaultRadius)
                
            }
        }
        self.initView?.toolBoardCollectionView.reloadData()
        
    }
    
    
    public func changeHeight(height : CGFloat){
        self.collectionHeight = height
        self.frame = CGRect(x:0, y:0, width: self.collectionWith, height: self.collectionHeight)
    }
    
    
    public func changeSpaceBetweenItem(spacingApplied spacing : CGFloat, for direction : [Direction]) {
        for d in direction{
            switch(d)
            {
            case .top:
                self.cellSpacingTop = spacing
                break
            case .bottom:
                self.cellSpacingBottom = spacing
                break
            case .left:
                self.cellSpacingLeft = spacing
                break
            case .right:
                self.cellSpacingRight = spacing
                break
            }
        }
        
        self.refresh()
    }
    
    
    
    public func changeItemsSize(size : CGSize){
        self.cellWidth = size.width
        self.cellHeight = size.height
        self.refresh()
    }
    
    
    public func changeMinimumLineSpacing(lineSpacing : CGFloat) {
        self.minimumSpaceBeetweenCell = lineSpacing
        self.refresh()
    }
    
    
    public func centerItems(margin : CGFloat){
        self.minimumSpaceBeetweenCell = margin
        self.changeSpaceBetweenItem(spacingApplied: margin, for: [.top, .bottom, .left, .right])
    }
    
    //TOUT LES GETTERS
    public func getItemRadius(at index : Int) -> CGFloat{
        return radiusTab[index]
    }
    public func getItemColor(at index : Int) -> UIColor{
        return colorTab[index]
    }
    public func getDefaultItemRadius() -> CGFloat{
        return self.defaultRadius
    }
    public func getDefaultItemColor() -> UIColor{
        return self.defaultColor
    }
    public func getDefaultBackgroundColor() -> UIColor{
        return self.defaultBackgroundColor
    }
    public func getMinimumSpaceBeetweenItem() -> CGFloat{
        return self.minimumSpaceBeetweenCell
    }
    public func getToolBoardSize() -> CGSize{
        return CGSize(width: self.collectionWith, height: self.collectionHeight)
    }
    public func getItemsSize() -> CGSize{
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    public func getItemSpace(from direction : Direction) -> CGFloat{
        
        switch direction {
        case .top:
            return self.cellSpacingTop
            
        case .left:
            return self.cellSpacingLeft
            
        case .right:
            return self.cellSpacingRight
            
        case .bottom:
            return self.cellSpacingBottom

        }
        
        
    }
    public func getItemCount() -> Int{
        return self.itemNumber
    }
    
    public func getItemsNibName() -> String {
        return self.cellNibName
    }
    public func getReuseItemsIdentifier() -> String{
        return self.reuseCellIdentifier
    }
    
}

extension ToolBoard: UICollectionViewDelegate, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemNumber
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        
        collectionView.register(UINib.init(nibName: cellNibName, bundle: self.bundle), forCellWithReuseIdentifier: reuseCellIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath)
        
        delegate?.toolBoard(self, cellForItem: cell, indexPath: indexPath)
        
        if !self.isPersonalizedCell{
            cell.backgroundColor = self.colorTab[indexPath.row]
            cell.layer.cornerRadius = self.radiusTab[indexPath.row]
        }
        
        
        
        
        return cell
        
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.toolBoard(self, didSelectObject: indexPath.row)
    }
    
    
}



