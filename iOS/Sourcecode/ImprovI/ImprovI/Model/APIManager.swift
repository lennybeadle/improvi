//
//  APIManager.swift
//  ImprovI
//
//  Created by Macmini on 1/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    static let SERVER = "http://lennybeadle.com/improvi/api.php?"
    
    class func dataFromResponse(json: Any?) -> Any? {
        if let json = json as? [String: Any]{
            if let success = json["success"] as? Int {
                if success == 1 {
                    if let data = json["data"] {
                        return data
                    }
                }
                else {
                    if let msg = json["msg"] as? String {
                        UIApplication.shared.keyWindow?.rootViewController?.showError(text: msg)
                        print(msg)
                    }
                }
            }
        }
        return nil
    }
    
    class func register(with userName: String, fullName: String, email: String, password: String, photo: UIImage? = nil, completion: ((User?)->Void)? = nil) {
        var parameters = [String: String]()
        parameters["user_name"] = userName
        parameters["full_name"] = fullName
        parameters["email"] = email
        parameters["password"] = password
        
        let url = SERVER + "action=register"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let dict = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    let user = User(id: "\(dict["id"]!)")
                    user.fullName = dict["full_name"] as! String
                    user.emailAddress = dict["email"] as! String
                    user.userName = dict["name"] as! String
                    if let since = dict["member_since"] {
                        user.dateJoined = Date(timeIntervalSince1970: "\(since)".doubleValue)
                    }
                    user.password = dict["password"] as! String
                    if let completion = completion {
                        completion(user)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("register failed")
        }
    }
    
    class func login(with userName: String?, email: String?, password: String, completion: ((User?, [Programme]?)->Void)? = nil) {
        var parameters = [String: String]()
        if let name = userName {
            parameters["user_name"] = name
        }
        else if let email = email{
            parameters["email"] = email
        }
        parameters["password"] = password
        
        let url = SERVER + "action=login"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")

                if let dict = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    let user = User(id: "\(dict["id"]!)")
                    user.fullName = dict["full_name"] as! String
                    user.emailAddress = dict["email"] as! String
                    user.userName = dict["name"] as! String
                    if let since = dict["member_since"] {
                        user.dateJoined = Date(timeIntervalSince1970: "\(since)".doubleValue)//Date.parse(dict["member_since"] as! String, format: "yyyy-MM-dd HH:mm:ss")
                    }
                    user.password = dict["password"] as! String
                    user.totalIXP = "\(dict["ixp"]!)".intValue
                    
                    if let programmeDict = dict["program_info"] as? [Any] {
                        let programmes = programmeDict.map {Programme.from(dict: $0 as! [String: Any])}
                        if let completion = completion {
                            completion(user, programmes)
                        }
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil, nil)
            }
            
            print("login failed")
        }
    }
    
    class func getProgramme(userId: String, completion: (([Programme]?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=getProgramList"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [Any]{
                    if let completion = completion {
                        let programmes = data.map {Programme.from(dict: $0 as! [String: Any])}
                        completion(programmes)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("get programme failed")
        }
    }
    
    class func addProgramme(userId: String, programmeId: String, completion: ((Programme?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        
        let url = SERVER + "action=takeProgram"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    if let completion = completion {
                        let programme = Programme.from(dict: data)
                        completion(programme)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("add programme failed")
        }
    }
    
    class func removeProgramme(userId: String, programmeId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        
        let url = SERVER + "action=deleteProgram"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let _ = self.dataFromResponse(json: response.result.value){
                    if let completion = completion {
                        completion(true)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(false)
            }
            print("remove programme failed")
        }
    }
    
    class func getNewTask(userId: String, programmeId: String, completion: ((Programme?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        
        let url = SERVER + "action=takeTaskCyclically"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    if let completion = completion {
                        let programme = Programme.from(dict: data)
                        completion(programme)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("get new tasks failed")
        }
    }
    
    class func completeTask(userId: String, programmeId: String, taskId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        parameters["task_id"] = taskId

        let url = SERVER + "action=completeTask"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let _ = self.dataFromResponse(json: response.result.value){
                    if let completion = completion {
                        completion(true)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(false)
            }
            print("complete task failed")
        }
    }
    
    class func loadQuestion(completion: (([Question]?)->Void)?) {
        let url = SERVER + "action=questionAnswers"
        Alamofire.request(url, method: .post).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = self.dataFromResponse(json: response.result.value) as? [Any]{
                    if let completion = completion {
                        let questions = data.map {Question.from(dict: $0 as! [String: Any])}
                        completion(questions)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("complete task failed")
        }
    }
    
    class func updateProfile(userId: String, userName: String!, fullName: String!, email: String!, password: String!, photo: UIImage!, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        if userName != nil {
            parameters["user_name"] = userName
        }
        if fullName != nil {
            parameters["full_name"] = userName
        }
        if email != nil{
            parameters["email"] = email
        }
        if password != nil{
            parameters["password"] = password
        }
        
        let url = SERVER + "action=updateUserProfile"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let _ = self.dataFromResponse(json: response.result.value){
                    if let completion = completion {
                        completion(true)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(false)
            }
            print("update profile success")
        }
    }
    
    class func loadTraits(userId: String, completion: (([TraitPoint]?, Int)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=userActivityInfo"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    var ixp = -1
                    if let ixpVal = data["ixp"] as? Int{
                        ixp = ixpVal
                    }
                    
                    if let traitData = data["trait"] as? [Any]{
                        let traitPoints = traitData.map {TraitPoint.from(dict: $0 as! [String: Any])}
                        if let completion = completion {
                            completion(traitPoints, ixp)
                        }
                        return
                    }
                }
            }
            
            if let completion = completion {
                completion(nil, -1)
            }
            print("User Traits Info success")
        }
    }
}
