//
//  OptionsCollectionViewCell.swift
//  LaundryApp
//


import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var viewContainer: BaseUIView!
    
    @IBOutlet weak var colorView: BaseUIView!
    

    
    var animated = false
    
    func configCell(color : UIColor) {
    //func configCell(data : (imgName : String, title : String)) {
        imgTick.isHidden = true
        colorView.backgroundColor = color
        colorView.cornerRadius = DesignUtility.getValueFromRatio(15)
//        imgOptions.tintColor = UIColor.darkGray
//        lblOptions.text = data.title
//        imgOptions.image = UIImage.init(named: data.imgName)
//        viewContainer.fillThemeColor = "white"
//        imgOptions.tintColor = UIColor.darkGray
//        lblOptions.fontColorTheme = "darkGray"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
