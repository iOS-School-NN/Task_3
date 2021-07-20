//
//  RouterableController.swift
//  task3.ios.school
//
//  Created by XO on 19.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation

protocol Routerable {
    associatedtype Router
    
    var router: Router? { get set }
}
