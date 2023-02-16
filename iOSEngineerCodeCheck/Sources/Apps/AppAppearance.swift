//
//  AppAppearance.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/02/11.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// アプリの共通している部分は、AppAppearanceを設けて、別途に使うと効率的であると考える
final class AppAppearance {
    static func setUpAppearance() {
        UIBarButtonItem.appearance().tintColor = .label
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
    }
}
