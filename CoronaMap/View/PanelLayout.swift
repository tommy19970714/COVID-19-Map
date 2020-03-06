//
//  PanelLayout.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit
import FloatingPanel

class PanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip]
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .tip: return 200
            default: return nil
        }
    }
}
