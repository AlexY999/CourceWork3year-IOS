//
//  UIConst.swift
//  SwapProject
//
//  Created by alexey on 08.09.2022.
//

import Foundation
import UIKit

enum SegueTags: String{
    case goToMenuWindowTag = "goToMenuWindow"
    case goToCarWindowTag = "goToCarWindow"
    case goToFineWindowTag = "goToFineWindow"
}


class UIKitAddictional{
    let formatter = DateFormatter()
    let cornerRadius = CGFloat(12)
    let headerHeight = CGFloat(12)
    
    init(){
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SS"
        formatter.timeZone = TimeZone(identifier: "UTC")
    }

    
  
    func setShadowAndCorners(shadowLayer:UIView){
        setShadow(shadowLayer: shadowLayer)
        shadowLayer.layer.cornerRadius = cornerRadius
    }
    
    func setShadow(shadowLayer:UIView){
        shadowLayer.layer.shadowColor = UIColor.black.cgColor
        shadowLayer.layer.shadowOffset = CGSize(width: 2, height: 3)
        shadowLayer.layer.shadowOpacity = 0.07;
        shadowLayer.layer.shadowRadius = 8.0;
    }
    
    func setTextField(textField:UIView){

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        setShadowAndCorners(shadowLayer: textField)
    }
    
//    func setActiveButton(button: UIButton, active: Bool){
//        if active{
//            button.backgroundColor = UIColor(uiColors: .orange)
//            button.isEnabled = true
//        }else{
//            button.backgroundColor = UIColor(uiColors: .buttonGrey)
//            button.isEnabled = false
//        }
//    }
    
    func setTableViewHeader(tableView:UITableView){
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
        tableView.tableHeaderView  = header
    }

    func setMaskedCorners(view:UIView){
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 10.0, y: 10.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }

    func checkPassword(textField: UITextField, upperAndLowerCaseCharactersToggle:UIStackView? = nil, oneDigitToggle:UIStackView? = nil, specialCharactersToggle:UIStackView? = nil, minimumCharactersToggle:UIStackView? = nil) -> Bool {
        var isValidPassword = true
        if let txt = textField.text {
            if (txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil) && (txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil){
                upperAndLowerCaseCharactersToggle?.tintColor = .systemGreen
            }else{
                upperAndLowerCaseCharactersToggle?.tintColor = .gray
                isValidPassword = false
            }
            if (txt.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) {
                oneDigitToggle?.tintColor = .systemGreen
            }else{
                oneDigitToggle?.tintColor = .gray
                isValidPassword = false
            }
            if txt.containsSpecialCharacter {
                specialCharactersToggle?.tintColor = .systemGreen
            }else{
                specialCharactersToggle?.tintColor = .gray
                isValidPassword = false
            }
            if txt.count >= 8 {
                minimumCharactersToggle?.tintColor = .systemGreen
            }else{
                minimumCharactersToggle?.tintColor = .gray
                isValidPassword = false
            }
        }

        return isValidPassword
    }
    
    func getTextAfterDot(text:String) -> String{
        let range = text.range(of: ".")
        if range != nil{
            let index: Int = text.distance(from: text.startIndex, to: range!.lowerBound)
            
            var result = text
            result.removeFirst(index)
            return result
        }
        
        return ""
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = capitalizingFirstLetter()
    }
}

extension String {
   var containsSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z0-9].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}

class ShadowedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setShadowAndCorners(shadowLayer:UIView){
        let uiKit = UIKitAddictional()
        uiKit.setShadowAndCorners(shadowLayer: shadowLayer)
        clipsToBounds = false
        layer.masksToBounds = true
        contentView.layer.masksToBounds = true
        selectionStyle = .none
    }

}
