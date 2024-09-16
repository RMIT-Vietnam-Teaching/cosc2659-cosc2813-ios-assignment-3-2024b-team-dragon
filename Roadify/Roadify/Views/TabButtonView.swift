//
//  TabButtonView.swift
//  Roadify
//
//  Created by Cường Võ Duy on 13/9/24.
//

import Foundation
import SwiftUI

struct TabButtonView: View {
	var viewIsSelected: String
	var viewIsNotSelected: String
	var isSelected: Bool
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack {
				if isSelected {
					Image(viewIsSelected)
						.resizable()
						.frame(width: 25, height: 25)
					Circle()
						.frame(width: 4, height: 4)
						.foregroundColor(Color("SubColor"))
				} else {
					Image(viewIsNotSelected)
						.resizable()
						.frame(width: 25, height: 25)
				}
			}
		}
		.frame(maxWidth: .infinity)
	}
}
