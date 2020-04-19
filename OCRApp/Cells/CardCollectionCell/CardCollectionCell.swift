//
//  CardCollectionCell.swift
//  OCRApp
//


import UIKit

class CardCollectionCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardsView!
    var animated = false
    @IBOutlet weak var imgCard: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(indexPath : IndexPath) {
        
        print(self.frame)
        cardView.setCardData(data: nil, row: indexPath.row)
        //func configCell(data : (imgName : String, title : String)) {
      //  colorView.backgroundColor = color
        //        imgOptions.tintColor = UIColor.darkGray
        //        lblOptions.text = data.title
        //        imgOptions.image = UIImage.init(named: data.imgName)
        //        viewContainer.fillThemeColor = "white"
        //        imgOptions.tintColor = UIColor.darkGray
        //        lblOptions.fontColorTheme = "darkGray"
        
        
    }
}
