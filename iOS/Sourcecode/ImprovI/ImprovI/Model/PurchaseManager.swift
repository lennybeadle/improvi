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

enum Products: Int{
    case product_10_feathers = 0
    case product_25_feathers = 1
    case product_50_feathers = 2
    case product_100_feathers = 3

    var identifier: String {
        return Products.productIdentifiers[self.rawValue]
    }
    
    var feathers: Int {
        return Products.productFeathers[self.rawValue]
    }
    
    var price: CGFloat {
        return Products.productPrices[self.rawValue]
    }
    
    var priceString: String {
        return String(format: "$%.2f", self.price)
    }
    
    static let productFeathers = [10, 25, 50, 100]
    static let productPrices: [CGFloat] = [0.99, 1.99, 2.99, 4.99]
    static let productIdentifiers = ["product_10_feathers", "product_25_feathers", "product_50_feathers", "product_100_feathers"]
    static let productIdentifiersSet: Set<String> = ["product_10_feathers", "product_25_feathers", "product_50_feathers", "product_100_feathers"]
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
