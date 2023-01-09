//
//  Login.swift
//  SwapProject
//
//  Created by alexey on 01.09.2022.
//

import Foundation

class UserLogin
{
    class LoginClass{
        var email:String
        var password:String
        
        init(email:String, password:String) {
            self.email = email
            self.password = password
        }

    func SingIn(login:LoginClass, twoFactorToken:String? = nil, callback:@escaping((Bool) -> Void))
    {
        var json: [String: Any] = [:]

        if login.isPhone{
            json[LoginTags.phone.rawValue] = login.phoneEmail
        }else{
            json[LoginTags.email.rawValue] = login.phoneEmail
        }
        
        json[LoginTags.password.rawValue] = login.password
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        var request = URLRequest(url: URL(string: singInUrl, relativeTo: apiUrl)!)
        request.httpMethod = "POST"

        if twoFactorToken != nil{
            request.setValue(twoFactorToken, forHTTPHeaderField: "X-Two-Factor-Token")
        }
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                var isLogin = false
                var twoFactor:TwoFactorAuthenticationViewController.TwoFactor? = nil
                
                for response in responseJSON{
                    if response.key == "token"
                    {
                        User.shared.jwsToken = "\(response.value)"
                        isLogin = true
                    }
                    else if response.key == "refreshToken"{
                        User.shared.refreshToken = "\(response.value)"
                    }
                    else if response.key == "data"{
                        if let datas = response.value as? [String: Any]
                        {
                            for data in datas{
                                if data.key == "twoFactor"{
                                    let value = data.value
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject: value)
                                        let instance = try JSONDecoder().decode(TwoFactorAuthenticationViewController.TwoFactor.self, from: jsonData)
                                        twoFactor = instance
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }
                callback(isLogin, twoFactor)
            }
        }

        task.resume()
    }
    
    func SingUp(login:LoginClass, callback:@escaping((Bool) -> Void))
    {
        var isCreated = false
        var json: [String: Any] = [:]

        if login.isPhone{
            json[LoginTags.phone.rawValue] = login.phoneEmail
        }else{
            json[LoginTags.email.rawValue] = login.phoneEmail
        }
        
        json[LoginTags.password.rawValue] = login.password
        

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        var request = setPostRequest(url: singUpUrl)
        
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                for response in responseJSON{
                    if response.key == "status"
                    {
                        if response.value as! String == "success" {
                            isCreated = true
                        }else{
                            isCreated = false
                        }
                    }
                    print(response.key + " \(response.value)")
                }
            }
            
            callback(isCreated)
        }

        task.resume()
    }
    
    enum LoginTags: String
    {
        case email
        case password
        case token
    }
    
    enum ConfirmationTags: String{
        case reset_password
        case identifier_verify
    }
}
