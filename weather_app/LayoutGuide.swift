//
//  LayoutGuide.swift
//  weather_app
//
//  Created by Tony Wang on 4/25/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import Foundation
import UIKit

enum fontClass {
    case stdTitle
    case stdBody
}

struct LayoutGuide {
    static func stdFonts(for type: fontClass) -> UIFont {
        switch type {
        case .stdTitle:
            let font = UIFont.systemFont(ofSize: 25, weight: .bold)
            return font
        default:
            let font = UIFont.systemFont(ofSize: 20, weight: .medium)
            return font
        }
    }
    
    
}
