//
//  CarWashDataModel.swift
//  CarFit
//
//  Created by Nikhil on 07/09/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - Carwash
struct Carwash:Codable {
    let success: Bool?
    let message: String?
    let data: [CarWashItem]?
    let code: Int?
}

// MARK: - Carwashitem
struct CarWashItem:Codable,DateProtocol {
    let visitID, homeBobEmployeeID, houseOwnerID: String?
    let isBlocked: Bool?
    let startTimeUtc, endTimeUtc, title: String?
    let isReviewed, isFirstVisit, isManual: Bool?
    let visitTimeUsed: Int?
    let rememberToday: String?
    let houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress: String?
    let houseOwnerZip, houseOwnerCity: String?
    let houseOwnerLatitude, houseOwnerLongitude: Double?
    let isSubscriber: Bool?
    let rememberAlways: String?
    let professional:String?
    let visitState: CarWashState?
    let stateOrder: Int?
    let expectedTime: String?
    let tasks: [Task]?
    let houseOwnerAssets, visitAssets, visitMessages: [String]?
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let startDateString = startTimeUtc
        {
            return dateFormatter.date(from: startDateString)

        }
        return nil
    }
}
enum CarWashState:String,Codable
{
    case todo = "ToDo"
    case done = "Done"
    case inProgress = "InProgress"
    case rejected = "Rejected"
}
// MARK: - Task
struct Task:Codable {
    let taskID, title: String?
    let isTemplate: Bool?
    let timesInMinutes, price: Int?
    let paymentTypeID, createDateUTC, lastUpdateDateUTC: String?
    let paymentTypes: String?
}
