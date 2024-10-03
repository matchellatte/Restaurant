//
//  ActivityView.swift
//  Restaurant
//
//  Created by STUDENT on 9/26/24.
//

import Foundation
import SwiftUI

struct ActivityView: View {
    var restaurant: Restaurant
    var isFavorite: Bool
    var toggleFavorite: () -> Void
    var makeReservation: () -> Void

    var body: some View {
        HStack {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(restaurant.type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)

            Spacer()

            Button(action: {
                toggleFavorite()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)
        .contextMenu {
            Button(action: {
                toggleFavorite()
            }) {
                Label(isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: isFavorite ? "heart.fill" : "heart")
            }
            
            Button(action: {
                makeReservation()
            }) {
                Label("Make a Reservation", systemImage: "calendar")
            }
        }
    }
}
