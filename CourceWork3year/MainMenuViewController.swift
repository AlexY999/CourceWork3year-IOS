//
//  MainMenuViewController.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import UIKit

class MainMenuViewController: MenuViewController {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var UserIDLabel: UILabel!
    
    @IBOutlet weak var carsTableView: UITableView!
    
    private let cellTag = "tokenCell"
    private let emptyCellTag = "emptyCell"
    
    private var cars:[Car] = []
    private var currentCar:Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBGView(view: bgView)
        
        uiKit.setShadowAndCorners(shadowLayer: infoView)
        
        carsTableView.delegate = self
        carsTableView.dataSource = self
        uiKit.setTableViewHeader(tableView: carsTableView)
    }
    
    override func loadInfo() {
        requests.getUserInfo(callback: setUserInfo)
        requests.getAllCars(callback: setUserCars)
        requests.getAllRules{_ in }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case SegueTags.goToCarWindowTag.rawValue:
            if let vs = segue.destination as? CarViewController{
                vs.car = currentCar
            }
        default:
            break
        }
    }
    
    private func setUserInfo(info:UserInfo){
        DispatchQueue.main.async { [self] in
            firstNameLabel.text = "First name: \(info.firstName)"
            lastNameLabel.text = "Last name: \(info.lastName)"
            emailLabel.text = "Email: \(info.email)"
            UserIDLabel.text = "UserID: \(info.userID)"
        }
    }
    
    private func setUserCars(cars:[Car]){
        self.cars = cars
        DispatchQueue.main.async { [self] in
            carsTableView.reloadData()
        }
    }
    
    @IBAction func onSingOut(_ sender: Any) {
        User.shared.jwsToken = nil
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func onProClick(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "PRO Version", message: "Enter a password for PRO", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            if textField?.text == User.shared.secretPassword{
                
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainMenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cars.isEmpty{
            return 1
        }
        
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cars.isEmpty{
            let tableCell = tableView.dequeueReusableCell(withIdentifier: emptyCellTag, for: indexPath) as! EmptyWalletCell
            tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
            return tableCell
        }
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellTag, for: indexPath) as! CarCell
        tableCell.setShadowAndCorners(shadowLayer: tableCell.shadowLayer)
        tableCell.contentView.layer.masksToBounds = false
        tableCell.layer.masksToBounds = false

        let car = cars[indexPath.row]

        tableCell.nameOfCar.text = car.title
        tableCell.secondNameOfCar.text = car.description

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cars.isEmpty{return}
        
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row).")

        currentCar = cars[indexPath.row]
        performSegue(withIdentifier: SegueTags.goToCarWindowTag.rawValue, sender: nil)
    }
}

class CarCell: ShadowedTableViewCell{
    
    @IBOutlet weak var shadowLayer: UIView!
    
    @IBOutlet weak var imageOfCar: UIImageView!
    @IBOutlet weak var nameOfCar: UILabel!
    @IBOutlet weak var secondNameOfCar: UILabel!
}


class EmptyWalletCell: ShadowedTableViewCell{
    
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var nothingFoundLabel: UILabel!
}

