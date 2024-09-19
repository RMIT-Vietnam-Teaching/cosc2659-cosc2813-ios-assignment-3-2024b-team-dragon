//
//  NavigationBarAppearance.swift
//  Roadify
//
//  Created by Nguyễn Tuấn Dũng on 20/9/24.
//

import Foundation
import SwiftUI

struct NavigationBarAppearance {
    static func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(Color("MainColor"))
        
        // Custom font and size for the navigation bar title
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: boldFont
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
