//
//  PickCardCell.swift
//  OCRApp
//


import UIKit
import HFCardCollectionViewLayout

class PickCardCell: HFCardCollectionViewCell {

    @IBOutlet weak var cardView: CardsView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCard: UIImageView!
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(card : Card) {
        
        var selectedRow:Int? = nil
        if let row = card.templateCardId.toInt() {
           selectedRow =  row - 1
        }
        //cardView.setCardData(data: card, row: card.templateCardId.toInt()! - 1)
        
        cardView.setCardData(data: card, row: selectedRow)
        
   // func configCell(card : CardInfo) {
        self.backgroundColor = UIColor.clear
        self.imgCard.image = #imageLiteral(resourceName: "emptycard1")
//        self.lblEmail.text = "Email:\(card.email)"
//        self.lblPosition.text = "Position:\(card.poition)"
//        self.lblWebsite.text = ""
//        self.lblLocation.text = "Location:\(card.address)"
//        self.lblPhone.text = "Phone:\(card.phone)"
//        self.lblName.text = "Name:\(card.name)"
        self.lblEmail.text = ""
        self.lblPosition.text = ""
        self.lblWebsite.text = ""
        self.lblLocation.text = ""
        self.lblPhone.text = ""
        self.lblName.text = ""
        //card.imgCard
        //func configCell(data : (imgName : String, title : String)) {
        //  colorView.backgroundColor = color
        //        imgOptions.tintColor = UIColor.darkGray
        //        lblOptions.text = data.title
        //        imgOptions.image = UIImage.init(named: data.imgName)
        //        viewContainer.fillThemeColor = "white"
        //        imgOptions.tintColor = UIColor.darkGray
        //        lblOptions.fontColorTheme = "darkGray"
    }
    
    func cardIsRevealed(_ isRevealed: Bool) {
      //  self.buttonFlip?.isHidden = !isRevealed
     //   self.tableView?.scrollsToTop = isRevealed
    }
    
}
