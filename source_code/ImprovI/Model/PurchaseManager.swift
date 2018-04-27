//
//  PurchaseManager.swift
//  Balagan
//
//  Created by Macmini on 5/15/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

enum Products: Int {
    case product_90_ixp = 0
    case product_200_ixp = 1
    case product_520_ixp = 2
    case product_5_feathers = 3
    case product_12_feathers = 4
    
    var identifier: String {
        return Products.productIdentifiers[self.rawValue]
    }
    
    var content: String {
        return Products.productContents[self.rawValue]
    }
    
    var price: CGFloat {
        return Products.productPrices[self.rawValue]
    }
    
    var priceString: String {
        return String(format: "$%.2f", self.price)
    }
    
    var isFeather: Bool {
        if self.rawValue < 3 {
            return false
        }
        return true
    }
    
    var value: Int {
        switch self {
        case .product_90_ixp:
            return 90
        case .product_200_ixp:
            return 200
        case .product_520_ixp:
            return 520
        case .product_5_feathers:
            return 5
        case .product_12_feathers:
            return 12
        default:
            return 0
        }
    }
    
    static let productContents = ["90 iXP", "200 iXP", "520 iXP", "Pack of 5 Feathers", "A Dozen(12 Feathers)"]
    static let productPrices: [CGFloat] = [0.99, 1.99, 4.99, 9.99, 19.99]
    static let productIdentifiers = ["product_90_ixp", "product_200_ixp", "product_520_ixp", "product_5_feathers", "product_12_feathers"]
    static let productIdentifiersSet: Set<String> = ["product_90_ixp", "product_200_ixp", "product_520_ixp", "product_5_feathers", "product_12_feathers"]
}

extension SKProduct {
    func priceString () -> String? {
        let priceFormatter = NumberFormatter()
        priceFormatter.formatterBehavior = .behavior10_4
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = self.priceLocale
        return priceFormatter.string(from: self.price)
    }
}

class PurchaseManager: NSObject {
    static let shared = PurchaseManager()
    var products = [SKProduct]()

    func completeIAPTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                // swiftlint:disable:next for_where
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased: \(purchase.productId)")
                }
            }
        }
    }
    
    func loadProducts(completion: ((_ result: Bool)->Void)?) {
        if self.products.count == 0 {
            
            SwiftyStoreKit.retrieveProductsInfo(Products.productIdentifiersSet) { result in
                if result.retrievedProducts.count > 0 {
                    self.products.removeAll()
                    self.products.append(contentsOf: result.retrievedProducts)
                    if let completion = completion{
                        completion(true)
                    }
                }
                else {
                    if let completion = completion{
                        completion(false)
                    }
                }
            }
        }
        else {
            if let completion = completion{
                completion(true)
            }
        }
    }
    
    func productForProductIdentifier(identifier: String) -> SKProduct? {
        for product in self.products {
            if product.productIdentifier == identifier{
                return product
            }
        }
        return nil
    }
    
    func purchaseProduct(product: String, completion: ((_ result: Bool)->Void)?) {        
        SwiftyStoreKit.purchaseProduct(product) { (result) in
            switch result {
            case .success(let productId):
                self.productPurchased(productID: product)
                if let completion = completion {
                    completion(true)
                }
                print("Purchase Success: \(productId)")
            case .error(let error):
                if let completion = completion {
                    completion(false)
                }
                print("Purchase Failed: \(error)")
            }
        }
    }
    
    func isPurchased(identifier: String) -> Bool {
        let userdefault = UserDefaults.standard
        return userdefault.bool(forKey: identifier)
    }

    func productPurchased(productID: String){
        let userdefault = UserDefaults.standard
        userdefault.set(true, forKey: productID)
        userdefault.synchronize()
    }
    
    func restorePurchases(completion: ((Bool, String)->Void)?) {
        if let completion = completion {
            SwiftyStoreKit.restorePurchases { (restoreResults) in
//                for (error, productId) in restoreResults.restoreFailedProducts {
//                    print ("\(error), product: \(productId!)")
//                }
                
                if restoreResults.restoredPurchases.count > 0 {
                    for purchase in restoreResults.restoredPurchases{
                        self.productPurchased(productID: purchase.productId)
                    }
                    completion(true, "Your purchase has been restored.")
                }
                else {
                    completion(false, "No purchase has been restored.")
                }
            }
        }
    }
}
