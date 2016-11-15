//
//  Types.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

protocol Value {}

extension Single: Value {}
extension Double: Value {}

typealias Single = UInt8
typealias Double = UInt16
typealias Program = [Operation]
