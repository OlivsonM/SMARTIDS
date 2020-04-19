//
//  AdsListingCollectionViewCell.swift
//  VIE
//


import UIKit

class AdsListingCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var lblAd: UILabel!
    @IBOutlet weak var lblAdDescription: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
//        setupForAnimation()
//        perform(#selector(animate), with: nil, afterDelay: 0.2)
    }
    
    func setupForAnimation()
    {
//        imgAd.isHidden = true
//        lblAd.isHidden = true
//        lblAdDescription.isHidden = true
    }
    
    @objc func animate()
    {
//        perform(#selector(flipImgAd), with: nil, afterDelay: 0.0)
//        perform(#selector(fliplblAd), with: nil, afterDelay: 0.1)
//        perform(#selector(fliplblAdDescription), with: nil, afterDelay: 0.2)
    }
    
    @objc func flipImgAd()
    {
//        imgAd.flipFromRight()
    }
    
    @objc func fliplblAd()
    {
//        lblAd.flipFromRight()
    }
    
    @objc func fliplblAdDescription()
    {
//        lblAdDescription.flipFromRight()
    }
    
    func setAdsData()
    {
        lblAd.text = "Ad 1"
    }
    
    func setFeaturedAdsData()
    {
        lblAd.text = "Featured Ad 1"
    }
    
    func setMyAdsData()
    {
        lblAd.text = "My Ad 1"
    }
    func setCardData(card : CardPending)
    {
        lblAdDescription.text = ""
        switch card.cardStatus {
        case PendingCardStatus.pending.rawValue:
            lblAd.text = "Pending"
            lblAd.textColor = UIColor.init(hexString:"a00606" )
            break
        case PendingCardStatus.processing.rawValue:
            lblAd.text = "Processing"
            lblAd.textColor = UIColor.init(hexString: "c4be21")
            break
        case PendingCardStatus.uploaded.rawValue:
            lblAd.text = "Uploaded"
            lblAd.textColor = UIColor.init(hexString: "117c50")
            break
        case PendingCardStatus.failed.rawValue:
            lblAd.text = "Failed to Process"
            lblAd.textColor = UIColor.init(hexString: "ff0000")
            break
        default: break
            
            
        }
        imgAd.image = Utility.loadImageFromPath(card.pendingImagePath)!
    }
    

    
} // end class AdsListingCollectionViewCell


