//
//  MenuHTTPRequests.swift
//  SwapProject
//
//  Created by alexey on 08.09.2022.
//

import Foundation

private let apiUrl = URL(string: "http://localhost:8080")!

class HTTPRequests{
    
    enum RequestsURL{
        static let register = "/api/users/register"
        static let login = "/api/users/login"
        static let user = "/api/users/user"
        static let allCars = "/api/cars/"
        static let addCar = "/api/cars/"
        static let deleteCar = "/api/cars/{CARID}"
        static let allCarFines = "/api/cars/{CARID}/fines"
        static let deleteCarFines = "/api/cars/{CARID}/fines/{FINEID}"
        static let allFineRules = "/api/fineCategories"
    }
    
    enum RequestLoginKeys{
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    enum RequestCarKeys{
        static let title = "title"
        static let description = "description"
    }
    
    enum ResponseKeys{
        static let token = "token"
    }
    
    private func setRequest(requestURL:URLRequest) -> URLRequest{
        var request = requestURL

        request.httpMethod = "POST"
        
        request.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",
                            forHTTPHeaderField: "Accept")
        
        if User.shared.jwsToken != nil{
            request.setValue("Bearer \(User.shared.jwsToken!)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }

    // MARK: get requests
    
    func getUserInfo(callback:@escaping(UserInfo) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.user, relativeTo: apiUrl)!)
        
        getRequest(requestURL: requestURL) { status, data in
            if status == true{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let instance = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                    callback(instance)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllCars(callback:@escaping([Car]) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.allCars, relativeTo: apiUrl)!)
        
        getRequest(requestURL: requestURL) { status, data in
            if status == true{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let instance = try JSONDecoder().decode([Car].self, from: jsonData)
                    callback(instance)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllCarFines(carId:Int, callback:@escaping([CarFine]) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.allCarFines.replacingOccurrences(of: "{CARID}", with: "\(carId)"), relativeTo: apiUrl)!)
        
        getRequest(requestURL: requestURL) { status, data in
            if status == true{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let instance = try JSONDecoder().decode([CarFine].self, from: jsonData)
                    callback(instance)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllRules(callback:@escaping([Rule]) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.allFineRules, relativeTo: apiUrl)!)

        getRequest(requestURL: requestURL) { status, data in
            if status == true{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data!)
                    let instance = try JSONDecoder().decode([Rule].self, from: jsonData)
                    callback(instance)
                    User.shared.rules = instance
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func getRequest(requestURL:URLRequest, callback:@escaping(Bool, Any?) -> Void){

        var request = setRequest(requestURL:requestURL)

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let data:[String: Any] = responseJSON
                for response in responseJSON{
                    if response.key == "error"
                    {
                        print(responseJSON)
                        callback(false, data)

                        return
                    }
                }
            }
            
            callback(true, responseJSON)
        }
        
        task.resume()
    }
    
    // MARK: post requests
    
    func login(email:String, password:String, callback:@escaping(Bool) -> Void){
        var json: [String: Any] = [:]
        json[RequestLoginKeys.email] = email
        json[RequestLoginKeys.password] = password

        let requestURL = URLRequest(url: URL(string: RequestsURL.login, relativeTo: apiUrl)!)
        
        postRequest(json: json, requestURL: requestURL) { status, data in
            if status == true{
                for value in data{
                    if value.key == ResponseKeys.token{
                        User.shared.jwsToken = value.value as? String
                    }
                }
            }
            
            callback(status)
        }
    }
    
    func register(email:String, password:String, firstName:String, lastName:String, callback:@escaping(Bool) -> Void){
        var json: [String: Any] = [:]
        json[RequestLoginKeys.email] = email
        json[RequestLoginKeys.password] = password
        json[RequestLoginKeys.firstName] = firstName
        json[RequestLoginKeys.lastName] = lastName

        let requestURL = URLRequest(url: URL(string: RequestsURL.register, relativeTo: apiUrl)!)
        
        postRequest(json: json, requestURL: requestURL) { status, data in
            if status == true{
                for value in data{
                    if value.key == ResponseKeys.token{
                        User.shared.jwsToken = value.value as? String
                    }
                }
            }
            
            callback(status)
        }
    }
    
    func createCar(title:String, description:String, callback:@escaping(Bool) -> Void){
        var json: [String: Any] = [:]
        json[RequestCarKeys.description] = description
        json[RequestCarKeys.title] = title
        
        let requestURL = URLRequest(url: URL(string: RequestsURL.addCar, relativeTo: apiUrl)!)
        
        postRequest(json: json, requestURL: requestURL) { status, data in
            callback(status)
        }
    }
    
    private func postRequest(json: [String: Any] ,requestURL:URLRequest, callback:@escaping(Bool, [String: Any]) -> Void){

        var request = setRequest(requestURL:requestURL)

        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let data:[String: Any] = responseJSON
                for response in responseJSON{
                    if response.key == "error"
                    {
                        print(responseJSON)
                        callback(false, data)

                        return
                    }
                }

                callback(true, data)
            }
        }
        
        task.resume()
    }
    
    
    // MARK: delete requests
    
    func deleteCar(carId:Int, callback:@escaping(Bool) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.deleteCar.replacingOccurrences(of: "{CARID}", with: "\(carId)"), relativeTo: apiUrl)!)

        deleteRequest(requestURL: requestURL) { status, data in
            callback(status)
        }
    }
    
    func deleteCarFine(carId:Int, fineId:Int, callback:@escaping(Bool) -> Void){
        let requestURL = URLRequest(url: URL(string: RequestsURL.deleteCarFines.replacingOccurrences(of: "{CARID}", with: "\(carId)").replacingOccurrences(of: "{FINEID}", with: "\(fineId)"), relativeTo: apiUrl)!)

        deleteRequest(requestURL: requestURL) { status, data in
            callback(status)
        }
    }
    
    private func deleteRequest(requestURL:URLRequest, callback:@escaping(Bool, [String: Any]) -> Void){

        var request = setRequest(requestURL:requestURL)

        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let data:[String: Any] = responseJSON
                for response in responseJSON{
                    if response.key == "error"
                    {
                        print(responseJSON)
                        callback(false, data)

                        return
                    }
                }

                callback(true, data)
            }
        }
        
        task.resume()
    }
}
