//
//  Reusable.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }
