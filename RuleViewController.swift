//
//  RuleViewController.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import UIKit

class RuleViewController: MenuViewController {

    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var fineID: UILabel!
    @IBOutlet weak var finePrice: UILabel!
    @IBOutlet weak var fineCategory: UILabel!
    @IBOutlet weak var fineDate: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infoView: UIView!

    var carFine:CarFine!
    var car:Car!
    
    private let cellTag = "tokenCell"
    private let emptyCellTag = "emptyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopGestureRecognizer()
        setBGView(view: bgView)
        uiKit.setShadowAndCorners(shadowLayer: infoView)
    }
    
    override func loadInfo() {
        setFine()
        
    }
    
    private func setFine(){
        carId.text = "CarID: \(carFine.carID)"
        userId.text = "UserId: \(carFine.userID)"
        fineID.text = "FineID: \(carFine.fineID)"

        finePrice.text = "Fine price: \(carFine.finePrice) $"
        fineCategory.text = "Fine category: \(carFine.fineCategory)"
        fineDate.text = "Fine date from 1970: \(carFine.fineDate) s"
    }
    
    @IBAction func payFine(_ sender: Any) {
        if let url = URL(string: "https://www.liqpay.ua/uk/") {
            UIApplication.shared.open(url)
        }
        
        requests.deleteCarFine(carId: car.carID, fineId: carFine.fineID) { status in
            if status{
                DispatchQueue.main.async {[self] in
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
