//
//  OptionsView.swift
//  LaundryApp
//


import UIKit


protocol OptionsViewProtocol : class {
    func didSelectItemAtIndex(index : Int) -> Void
}

class  OptionsView : UIView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblHeading: BaseUILabel!
    @IBOutlet weak var colViewOptions: UICollectionView!
    var lastSelectedImage : UIImageView!
  //  var dataArray = [(imgName : String , title : String)]()
    var dataArray = [(UIColor)]()
    weak var delegateOptions:OptionsViewProtocol?
     let reuseIdentifier = "OptionsCollectionViewCell"
    var isCellAnimated = false
    var selectedCellIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //--ww fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commomInit()
    }
    
    
    
    func commomInit(){
        Bundle.main.loadNibNamed("OptionsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        configColView()
    }
    
    func configColView(){
        colViewOptions.delegate = self
        colViewOptions.dataSource = self
        
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        colViewOptions?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
extension OptionsView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = colViewOptions?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!
        OptionsCollectionViewCell
        
        cell.configCell(color:  dataArray[indexPath.item])
        print(selectedCellIndex)
        if indexPath.row == selectedCellIndex{
            cell.imgTick.isHidden = false
         //setCellSelected(cell: cell)
        }
        //cell.isHidden = true
//        if cell.animated == false && isCellAnimated == false{
//
//        let delay = Float(indexPath.row) * 0.10
//        perform(#selector(self.flipCell), with: cell, afterDelay:TimeInterval(delay))
//        }else {
//            cell.isHidden = false
//
//        }
        cell.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
    }
    
    @objc func flipCell (cell : UICollectionViewCell) {
        Animations.flipView(view: cell)
    }
}

extension OptionsView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.colViewOptions.isUserInteractionEnabled = false
        let cell = colViewOptions.cellForItem(at: indexPath) as! OptionsCollectionViewCell
        
        self.selectedCellIndex = indexPath.row
        self.setCellSelected(cell: cell)
        self.delegateOptions?.didSelectItemAtIndex(index: indexPath.item)
        self.colViewOptions.isUserInteractionEnabled = true
        /*
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                                       animations: {
                                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        self.selectedCellIndex = indexPath.row
                                        self.setCellSelected(cell: cell)
                                        self.delegateOptions?.didSelectItemAtIndex(index: indexPath.item)
                                         self.colViewOptions.isUserInteractionEnabled = true
                        },
                                       completion: nil
                        )
                        
        }
        )
        */
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = colViewOptions.cellForItem(at: indexPath) {
            let cell1 = cell as! OptionsCollectionViewCell
            cell1.imgTick.isHidden = true
            return
        }
       // collectionView.reloadData()
       // cell.viewContainer.fillThemeColor = "white"
//        cell.imgOptions.tintColor = UIColor.darkGray
//        cell.lblOptions.fontColorTheme = "darkGray"
        
    }
    
    
    func setCellSelected (cell : OptionsCollectionViewCell) {
        if let imgTick = lastSelectedImage {
            imgTick.isHidden = true
        }
        cell.imgTick.isHidden = false
        colViewOptions.reloadData()
       // cell.viewContainer.fillThemeColor = "baseTheme"
//        cell.imgOptions.tintColor = UIColor.white
//        cell.lblOptions.fontColorTheme = "white"
       
    }
}

extension OptionsView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  return CGSize(width:self.colViewOptions.frame.width / 3 - DesignUtility.getValueFromRatio(10), height:self.colViewOptions.frame.height - DesignUtility.getValueFromRatio(10))
        
        return CGSize(width: DesignUtility.getValueFromRatio(30), height: DesignUtility.getValueFromRatio(30))
        //return CGSize(width: DesignUtility.getValueFromRatio(110), height: DesignUtility.getValueFromRatio(105))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return  DesignUtility.getValueFromRatio(15)
    }

   

    
    
}
