//
//  Recruit.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/17.
//

import Foundation

struct Recruit {
    let part: String
    let num: Int
    let skills: [String]
    let requirement: String
}

extension Recruit: Hashable { }
