//
//  CarViewController.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import UIKit

class CarViewController: MenuViewController {

    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var titleOfCar: UILabel!
    @IBOutlet weak var descriptionOfCar: UILabel!
    @IBOutlet weak var totalExpense: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infoView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var car:Car!
    private var carFines:[CarFine] = []
    private var currentCarFines:CarFine?
    
    private let cellTag = "tokenCell"
    private let emptyCellTag = "emptyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        uiKit.setTableViewHeader(tableView: tableView)

        setPopGestureRecognizer()
        setBGView(view: bgView)
        uiKit.setShadowAndCorners(shadowLayer: infoView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case SegueTags.goToFineWindowTag.rawValue:
            if let vs = segue.destination as? RuleViewController{
                vs.carFine = currentCarFines
                vs.car = car
            }
        default:
            break
        }
    }
    
    override func loadInfo() {
        setCar()
        
        requests.getAllCarFines(carId: car.carID, callback: setCarFines)
    }
    
    private func setCarFines(carFines:[CarFine]){
        self.carFines = carFines
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
    
    private func setCar(){
        carId.text = "CarID: \(car.carID)"
        userId.text = "UserId: \(car.userID)"
        titleOfCar.text = "Name: \(car.title)"
        descriptionOfCar.text = "Description: \(car.description)"
        totalExpense.text = "Price of fines: \(car.totalExpense) $"
    }
    
    @IBAction func deleteCar(_ sender: Any) {
        requests.deleteCar(carId: car.carID) { status in
            DispatchQueue.main.async { [self] in
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CarViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if carFines.isEmpty{
            return 1
        }
        
        return carFines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if carFines.isEmpty{
            let tableCell = tableView.dequeueReusableCell(withIdentifier: emptyCellTag, for: indexPath) as! EmptyWalletCell
            tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
            return tableCell
        }
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellTag, for: indexPath) as! FineCell
        tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
        tableCell.contentView.layer.masksToBounds = false
        tableCell.layer.masksToBounds = false

        let carFines = carFines[indexPath.row]

        tableCell.nameOfFine.text = "\(carFines.fineCategory)"

        for rule in User.shared.rules{
            if rule.fineCategoryID == carFines.fineCategory{
                tableCell.nameOfFine.text = (tableCell.nameOfFine.text ?? "") + "- \(rule.title)"
            }
        }
        tableCell.secondNameOfFine.text = "Fine price: \(carFines.finePrice) $"

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if carFines.isEmpty{return}
        
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row).")

        currentCarFines = carFines[indexPath.row]
        performSegue(withIdentifier: SegueTags.goToFineWindowTag.rawValue, sender: nil)
    }
}

class FineCell: ShadowedTableViewCell{
    
    @IBOutlet weak var shadowLayer: UIView!
    
    @IBOutlet weak var imageOfFine: UIImageView!
    @IBOutlet weak var nameOfFine: UILabel!
    @IBOutlet weak var secondNameOfFine: UILabel!
}
