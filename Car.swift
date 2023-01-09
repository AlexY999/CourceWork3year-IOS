//
//  Car.swift
//  CourceWork3year
//
//  Created by Алексей on 09.01.2023.
//

import Foundation

struct Car: Codable {
    let carID, userID: Int
    let title, description: String
    let totalExpense: Int

    enum CodingKeys: String, CodingKey {
        case carID = "carId"
        case userID = "userId"
        case title, description, totalExpense
    }
}

struct CarFine: Codable {
    let fineID, carID, userID, finePrice: Int
    let note, fineCategory: String
    let fineDate: Int

    enum CodingKeys: String, CodingKey {
        case fineID = "fineId"
        case carID = "carId"
        case userID = "userId"
        case finePrice, note, fineCategory, fineDate
    }
}

struct Rule: Codable {
    let userID: Int
    let title, description, fineCategoryID: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case title, description
        case fineCategoryID = "fineCategoryId"
    }
}
