//
//  ReusableIdentifier.swift
//  TrendingRepositpriesUIKit
//
//  Created by Zara on 11/06/2023.
//

import UIKit

public protocol ReusableIdentifier {
    static var reuseIdentifier: String { get }
}

public extension ReusableIdentifier {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

extension UITableViewCell: ReusableIdentifier {
    
}
