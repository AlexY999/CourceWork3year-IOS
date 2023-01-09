//
//  UserData.swift
//  SwapProject
//
//  Created by alexey on 08.09.2022.
//

import Foundation
import UIKit
import LocalAuthentication

enum KeysUserDefaults{
    static let jwsToken = "jwsToken"
    static let refreshToken = "refreshToken"
    static let email = "email"
}

enum KeysDecodeJWT{
    static let exp = "exp"
}

class User{
    static var shared = User()
    
    var rules:[Rule] = []
    var userInfo:UserInfo? = nil
    var secretPassword = "1212"
    
    var jwsToken:String?{
        get{
            return UserDefaults.standard.string(forKey: KeysUserDefaults.jwsToken)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: KeysUserDefaults.jwsToken)
            
            if newValue == nil {
                return
            }
            
            for decode in self.decode(jwtToken: newValue!){
                if decode.key == KeysDecodeJWT.exp{
                    var timeToExp = Date(timeIntervalSince1970: decode.value as! TimeInterval).timeIntervalSinceNow
                    print("timeToExpToken \(timeToExp)" )
                }
            }
        }
    }
    
    var uuid:String?

    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    private func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    private func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
}

struct UserInfo: Codable {
    let userID: Int
    let firstName, lastName, email, password: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, email, password
    }
}
