//
//  CarInfo.swift
//  getting-started-ios-sdk
//
//  Created by Muhannad Alnemer on 7/20/19.
//  Copyright © 2019 Smartcar. All rights reserved.
//

import Foundation

@objc public class CarInfo: NSObject {
    var vin: String?
    var make: String?
    var model: String?
    var year: Int?
    var id: String
    
    public init(vin: String? = nil, make: String? = nil, year: Int? = nil, model: String? = nil, id:String) {
        self.id = id
        self.vin = vin
        self.make = make
        self.year = year
        self.model = model
    }
}
