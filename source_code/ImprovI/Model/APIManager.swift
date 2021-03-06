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
                    return true
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
    
    class func login(with userName: String?, email: String?, password: String, completion: ((User?)->Void)? = nil) {
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
                    user.feathers = "\(dict["feather"]!)".intValue

                    if let completion = completion {
                        completion(user)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            
            print("login failed")
        }
    }
    
    class func getDailyTasks(completion: (([DailyTask]?)->Void)?) {
        let url = SERVER + "action=getDailyTasks"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [Any]{
//                    let standard = UserDefaults.standard
//                    standard.set(data, forKey: "dailytasks")
//                    DispatchQueue.global(qos: .background).async {
//                        standard.synchronize()
//                    }
                    
                    if let completion = completion {
                        let dailyTasks = data.map {DailyTask.from(dict: $0 as! [String: Any])}
                        completion(dailyTasks)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("get DailyTasks failed")
        }
    }
    
    class func getPrograms(userId: String, completion: (([Programme]?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=getPrograms"
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
    
    class func getProgramDetail(userId: String, programmeId: String, completion: (([String:Any]?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        
        let url = SERVER + "action=programDetail"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let dict = self.dataFromResponse(json: response.result.value) as? [String:Any] {
                    if let completion = completion {
                        completion(dict)
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
    
    class func unlockProgramme(userId: String, programmeId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        
        let url = SERVER + "action=unlockProgram"
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
            print("unlock programme failed")
        }
    }
    
    class func unlockTask(userId: String, programmeId: String, taskId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        parameters["task_id"] = taskId
        
        let url = SERVER + "action=unlockTask"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let _ = self.dataFromResponse(json: response.result.value) {
                    if let completion = completion {
                        completion(true)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(false)
            }
            print("unlock tasks failed")
        }
    }
    
    class func startTask(userId: String, programmeId: String, taskId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["program_id"] = programmeId
        parameters["task_id"] = taskId
        
        let url = SERVER + "action=startTask"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let _ = self.dataFromResponse(json: response.result.value) {
                    if let completion = completion {
                        completion(true)
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(false)
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
    
    class func getProgress(userId: String, completion: (([String:Any]?)->Void)?) {
//        {"msg": "Success to get progress", "success": 1, "data" : {"9":[{"task_id":"76","started_at":"0000-00-00 00:00:00","status":"0"},{"task_id":"67","started_at":"2017-12-23 00:27:26","status":"2"},{"task_id":"65","started_at":"0000-00-00 00:00:00","status":"0"}],"7":[]}}
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=getProgress"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let dict = self.dataFromResponse(json: response.result.value) as? [String:Any] {
                    if let completion = completion {
                        completion(dict)
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
    
    class func numberOfOnGoingTasks(userId: String, completion: ((String?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=onGoingTasks"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let dict = self.dataFromResponse(json: response.result.value) as? [String: Any] {
                    if let numOnGoing = dict["on_going_tasks"] {
                        if let completion = completion {
                            completion("\(numOnGoing)")
                        }
                    }
                    return
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("get ongoing tasks failed")
        }
    }
    
    
    
    class func featherPurchased(userId: String, feathers: Int, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["feather"] = "\(feathers)"
        
        let url = SERVER + "action=featherPurchased"
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
            print("Feather purchased migrated to Server successfully")
        }
    }
    
    class func ixpPurchased(userId: String, ixp: Int, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["ixp"] = "\(ixp)"
        
        let url = SERVER + "action=ixpPurchased"
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
            print("iXP purchased migratd to server successfully")
        }
    }
    
    class func convertIXPToFeathers(userId: String, feathers: Int, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["feathers"] = "\(feathers)"
        
        let url = SERVER + "action=convertIXPToFeather"
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
            print("Feathers purchased successfully")
        }
    }
    
    class func updateIxp(userId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["ixp"] = "50"
        
        let url = SERVER + "action=ixpPurchased"
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
            print("update to premium failed")
        }
    }
    
    class func updateToPremium(userId: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        let url = SERVER + "action=updateToPremium"
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
            print("update to premium failed")
        }
    }
    
    class func loadQuestion(userId: String, completion: (([Question]?)->Void)?) {
        let url = SERVER + "action=questionAnswers"
        var parameters = [String: String]()
        parameters["user_id"] = userId
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = self.dataFromResponse(json: response.result.value) as? [Any]{
                    if let completion = completion {
                        let questions = data.map {Question.from(dict: $0 as! [String: Any])}
                        let unAnswered = questions.filter({ (question) -> Bool in
                            return question.userAnswerId == nil
                        })
                        completion(unAnswered)
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
    
    class func submitAnswer(userId: String, questionId: String, answerId: String, completion: ((String?)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["question_id"] = questionId
        parameters["answer_id"] = answerId
        
        let url = SERVER + "action=submitAnswer"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    if let ixp = data["ixp"] {
                        if let completion = completion {
                            completion("\(ixp)")
                        }
                        return
                    }
                }
            }
            
            if let completion = completion {
                completion(nil)
            }
            print("submit answer success")
        }
    }
    
    class func changePassword(userId: String, password: String, oldPassword: String, completion: ((Bool)->Void)?) {
        var parameters = [String: String]()
        parameters["user_id"] = userId
        parameters["oldPassword"] = oldPassword
        parameters["password"] = password
        
        let url = SERVER + "action=changePassword"
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
        
        let url = SERVER + "action=userTraits"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("JSON: \(response.result.value!)")
                if let data = self.dataFromResponse(json: response.result.value) as? [String: Any]{
                    var ixp = 0
                    if let ixpVal = data["ixp"]{
                        ixp = "\(ixpVal)".intValue
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
