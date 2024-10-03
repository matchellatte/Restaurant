import SwiftUI

struct ContentView: View {
    
    @State var restaurants = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haigh", isFavorite: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)
    ]
    
    @State private var favorites: Set<String> = []
        @State private var reservations: [String: Date] = [:]
        @State private var showingReservationDatePicker = false
        @State private var selectedRestaurant: String?
        @State private var selectedDate = Date()

        var body: some View {
            NavigationView {
                List {
                    ForEach(restaurants.indices, id: \.self) { index in
                        let restaurant = restaurants[index]
                        NavigationLink(destination: RestaurantDetailView(
                            restaurantName: restaurant.name,
                            restaurantImage: restaurant.image,
                            restaurantLocation: restaurant.location,
                            restaurantType: restaurant.type,
                            isFavorite: favorites.contains(restaurant.name),
                            toggleFavorite: {
                                if favorites.contains(restaurant.name) {
                                    favorites.remove(restaurant.name)
                                } else {
                                    favorites.insert(restaurant.name)
                                }
                            },
                            reservationDate: reservations[restaurant.name],
                            updateReservation: { selectedDate in
                                reservations[restaurant.name] = selectedDate
                            }
                        )) {
                            ActivityView(
                                restaurant: restaurant,
                                isFavorite: favorites.contains(restaurant.name),
                                toggleFavorite: {
                                    if favorites.contains(restaurant.name) {
                                        favorites.remove(restaurant.name)
                                    } else {
                                        favorites.insert(restaurant.name)
                                    }
                                },
                                makeReservation: {
                                    selectedRestaurant = restaurant.name
                                    showingReservationDatePicker = true
                                }
                            )
                        }
                    }
                }
                .sheet(isPresented: $showingReservationDatePicker) {
                    VStack {
                        Text("Select Reservation Date for \(selectedRestaurant ?? "")")
                            .font(.headline)
                            .padding()

                        DatePicker("Reservation Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()

                        Button(action: {
                            if let restaurant = selectedRestaurant {
                                reservations[restaurant] = selectedDate
                            }
                            showingReservationDatePicker = false
                        }) {
                            Text("Confirm Reservation")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Restaurants")
            }
            .accentColor(.black)
        }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct RestaurantDetailView: View {
    var restaurant: Restaurant
    @State var isFavorite: Bool
    var toggleFavorite: () -> Void
    
    @State var reservationDate: Date?
    var updateReservation: (Date) -> Void

    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    @State private var showingConfirmationDialog = false
    @State private var showingAlert = false
    @State private var showingFavoriteAlert = false

    var body: some View {
        VStack {
            Image(restaurant.image)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .cornerRadius(10)

            Text(restaurant.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text(restaurant.location)
                .font(.title2)
                .foregroundColor(.secondary)

            Text(restaurant.type)
                .font(.title3)
                .foregroundColor(.gray)

            HStack {
                Button(action: {
                    toggleFavorite()
                    isFavorite.toggle()
                    showingFavoriteAlert = true
                }) {
                    Label(isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: isFavorite ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .padding(8)
                        .background(isFavorite ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)

                Button(action: {
                    showingDatePicker = true
                }) {
                    Text("Make a Reservation")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
                .sheet(isPresented: $showingDatePicker) {
                    VStack {
                        DatePicker("Select Date and Time", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                        
                        Button("Confirm Reservation") {
                            showingConfirmationDialog = true
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .confirmationDialog("Confirm Reservation", isPresented: $showingConfirmationDialog) {
                            Button("Confirm") {
                                updateReservation(selectedDate)
                                showingAlert = true
                                showingDatePicker = false
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Are you sure you want to confirm this reservation?")
                        }
                    }
                    .padding()
                }
            }

            Spacer()

            if let reservation = reservationDate {
                VStack {
                    Text("Reservation Details")
                        .font(.headline)
                        .padding(.top)

                    Text("Date & Time: \(formattedDate(reservation))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
            }
        }
        .navigationTitle(restaurant.name)
        .background(Color.white)
        .alert(isPresented: $showingFavoriteAlert) {
            Alert(
                title: Text(isFavorite ? "Added to Favorites" : "Removed from Favorites"),
                message: Text(isFavorite ? "\(restaurant.name) was added to your favorites." : "\(restaurant.name) was removed from favorites."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


#Preview {
    ContentView()
}
