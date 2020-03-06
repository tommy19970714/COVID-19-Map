//
//  CALayer+Extension.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {
    enum Direction {
        case top
        case bottom
    }

    public func addShadow(direction: Direction){
        switch direction {
        case .top:
            self.shadowOffset = CGSize(width: 0.0, height: -1)
        case .bottom:
            self.shadowOffset = CGSize(width: 0.0, height: 2)
        }
        self.shadowRadius = 1.5
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.5
    }
}
