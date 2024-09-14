//
//  RoundCorner.swift
//  Roadify
//
//  Created by Cường Võ Duy on 13/9/24.
//

import Foundation
import SwiftUI

struct RoundedCornerViewModel: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
