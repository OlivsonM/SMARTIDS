    //
//  CardCollectionView.swift
//  OCRApp
//

import UIKit
import AnimatedCollectionViewLayout

protocol CardViewProtocol : class {
    func didSelectItemAtIndex(index : Int) -> Void
    
}

class CardCollectionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionCardView: UICollectionView!
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    var slectedPage = 0
    
    @IBOutlet weak var pageControl: PageControl!
    var dataArray = [(UIColor)]()
    weak var delegateCards:CardViewProtocol?
    let reuseIdentifier = "CardCollectionCell"
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
        Bundle.main.loadNibNamed("CardCollectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        configColView()
    }
    
    func configColView(){
        collectionCardView.delegate = self
        collectionCardView.dataSource = self
        
       // pageControl.numberOfPages = 3
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionCardView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionCardView?.isPagingEnabled = true
        
       //  animator = (LinearCardAttributesAnimator(), false, 1, 1)
        animator = (LinearCardAttributesAnimator.init(minAlpha: 1.0, itemSpacing: 0.3, scaleRate: 0.85), false, 1, 1)
        
       // animator = (LinearCardAttributesAnimator.init(minAlpha: 1.0, itemSpacing: 0.1, scaleRate: 1.0), false, 1, 1)
        
        if let layout = collectionCardView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        slectedPage = Int(ceil(x/w))
        // Do whatever with currentPage.
        
        
    }
}

extension CardCollectionView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //  return CGSize(width:self.colViewOptions.frame.width / 3 - DesignUtility.getValueFromRatio(10), height:self.colViewOptions.frame.height - DesignUtility.getValueFromRatio(10))
      //   return CGSize(width: 100, height: 200)
       // return CGSize(width: DesignUtility.getValueFromRatio(30), height: DesignUtility.getValueFromRatio(30))
        //return CGSize(width: DesignUtility.getValueFromRatio(110), height: DesignUtility.getValueFromRatio(105))
        guard let animator = animator else { return self.bounds.size }
//        print(animator.2)
//        print(animator.3)
//        print(self.bounds)
//        print(DesignUtility.getValueFromRatio(414))
//        print(self.frame.size.width)
        print(DesignUtility.getValueFromRatio(414))
        //return CGSize(width: DesignUtility.getValueFromRatio(414), height: DesignUtility.getValueFromRatio(209))
        
        var size = CGSize(width: (self.bounds.width) / CGFloat(animator.2), height: self.bounds.height / CGFloat(animator.3))
        print(size)
        return CGSize(width: (self.bounds.width) / CGFloat(animator.2), height: self.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
      //  return  DesignUtility.getValueFromRatio(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}



extension CardCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegateCards?.didSelectItemAtIndex(index: indexPath.item)
//        self.collectionCardView.isUserInteractionEnabled = false
//        let cell = collectionCardView.cellForItem(at: indexPath) as! CardCollectionCell
//        
//        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
//                       animations: {
//                        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                        
//        },
//                       completion: { finished in
//                        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
//                                       animations: {
//                                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
//                                        self.selectedCellIndex = indexPath.row
//                                        self.setCellSelected(cell: cell)
//                                        self.delegateCards?.didSelectItemAtIndex(index: indexPath.item)
//                                        self.collectionCardView.isUserInteractionEnabled = true
//                        },
//                                       completion: nil
//                        )
//                        
//        }
//        )
//        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       // let cell = collectionCardView.cellForItem(at: indexPath) as! CardCollectionCell
        // cell.viewContainer.fillThemeColor = "white"
        //        cell.imgOptions.tintColor = UIColor.darkGray
        //        cell.lblOptions.fontColorTheme = "darkGray"
      //  cell.imgTick.isHidden = true
    }
    
    
    func setCellSelected (cell : CardCollectionCell) {
        //cell.imgTick.isHidden = false
        // cell.viewContainer.fillThemeColor = "baseTheme"
        //        cell.imgOptions.tintColor = UIColor.white
        //        cell.lblOptions.fontColorTheme = "white"
        
    }
}

extension CardCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return dataArray.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionCardView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!
        CardCollectionCell
        
        //cell.configCell(color:  dataArray[indexPath.item])
        
        cell.clipsToBounds = animator?.1 ?? true
        cell.configCell(indexPath: indexPath)
//        if indexPath.row == selectedCellIndex{
//            setCellSelected(cell: cell)
//        }
//        cell.isHidden = true
//        if cell.animated == false && isCellAnimated == false{
//
//            let delay = Float(indexPath.row) * 0.10
//            perform(#selector(self.flipCell), with: cell, afterDelay:TimeInterval(delay))
//        }else {
//            cell.isHidden = false
//
//        }
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
