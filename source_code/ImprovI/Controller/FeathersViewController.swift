//
//  FeathersViewController.swift
//  ImprovI
//
//  Created by Macmini on 12/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

class FeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgFeather: UIImageView!
    @IBOutlet weak var lblFeather: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwContainer.layer.cornerRadius = 10
        self.vwContainer.layer.shadowColor = UIColor.gray.cgColor
        self.vwContainer.layer.shadowOpacity = 0.3
        self.vwContainer.layer.shadowRadius = 5
        self.vwContainer.layer.shadowOffset = CGSize(width: 1, height: 4)
    }
    
    func resetWith(product: Products) {
        lblFeather.text = product.content
        if let skProduct = PurchaseManager.shared.productForProductIdentifier(identifier: product.identifier) {
            if let priceString = skProduct.priceString() {
                lblPrice.text = priceString
            }
            else {
                lblPrice.text = ""
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if !selected {
            vwContainer.backgroundColor = Constant.UI.foreColor
        }
        else {
            vwContainer.backgroundColor = Constant.UI.foreColorLight
        }
    }
}

class FeathersViewController: BaseViewController {
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var lblFeathers: UILabel!
    @IBOutlet weak var tblPrice: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vwBanner.layer.cornerRadius = 10
        self.vwBanner.layer.shadowColor = UIColor.gray.cgColor
        self.vwBanner.layer.shadowOpacity = 0.3
        self.vwBanner.layer.shadowRadius = 5
        self.vwBanner.layer.shadowOffset = CGSize(width: 1, height: 4)
        
        self.updateFeathers()
        self.loadProducts()
    }
    
    func updateFeathers () {
        lblFeathers.text = "\(Manager.shared.currentUser.feathers!)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tblPrice.reloadData()
    }
    
    func loadProducts() {
        if PurchaseManager.shared.products.count == 0 {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            PurchaseManager.shared.loadProducts { (result) in
                SVProgressHUD.dismiss()
                if (result) {
                    self.tblPrice.reloadData()
                }
            }
        }
        else {
            self.tblPrice.reloadData()
        }
    }
    
    @IBAction func onExchange(_ sender: Any) {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "FeatherConvertController") as! FeatherConvertViewController
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: false, completion: nil)
    }
}

extension FeathersViewController: FeatherConvertControllerDelegate {
    func exchangeCompleted() {
        lblFeathers.text = "\(Manager.shared.currentUser.feathers!)"
    }
}

extension FeathersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.tblPrice.bounds.height - 160)/5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PurchaseManager.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FEATHER_CELL", for: indexPath) as! FeatherTableViewCell
        if let product = Products(rawValue: indexPath.row) {
            cell.resetWith(product: product)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let product = Products(rawValue: indexPath.row) else {
            return
        }
                
        if let skProduct = PurchaseManager.shared.productForProductIdentifier(identifier: product.identifier) {
            if let priceString = skProduct.priceString() {
                self.askPurchaseFeather(text: "Are you going to purchase \(product.content) with \(priceString)?", completion: { (feathers) in
                    Manager.shared.purchaseFeathers(product: product, completion: { (result) in
                        self.updateFeathers()
                        self.tblPrice.reloadData()
                    })
                })
            }
        }
    }
}
