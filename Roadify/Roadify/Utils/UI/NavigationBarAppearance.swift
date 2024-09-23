/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 20/9/24
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

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
