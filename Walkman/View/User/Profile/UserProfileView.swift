//
//  UserProfileView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI
import MapKit

struct UserProfileView: View {
    @State private var Name: String = ""
    @State private var Addresses: [Address] = []
    @State private var Phone: String = ""
    @State private var Email: String = ""
    @State private var Orders: [Order] = []
    @State private var isLoggedOut = false
    @State private var showingLogOut = false
//    @StateObject var userManager: UserManager
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.914140, longitude: -77.384850), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @State var tracking: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ScrollView(.vertical) {
                    VStack {
                            if (viewModel.user?.address != nil) {
                                ForEach(viewModel.user?.address ?? [], id: \.self) { addr in
                                    HStack {
                                        VStack(spacing: 0) {
                                            Group {
                                                Text("School")
                                                    .font(.subheadline)
                                                    .padding(.top, 8)
                                                    .bold()

                                                Text("\(addr.street)")

                                                Text("\(addr.city) \(addr.state) \(addr.zip)")

                                                Text("\(addr.country)")
                                                    .padding(.bottom, 8)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                            .lineSpacing(2)
                                        }
                                    }
                                    Divider()
                                }
                                .onDelete { index in
                                    // delete item
                                }
                                
                                .padding(.leading)
                            }
//                        }.frame(width: g.size.width, height: g.size.height, alignment: .center)
                        // MARK: Example map of user current location usage
                    }
                    .scrollContentBackground(.visible)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("\(viewModel.user?.name ?? "Profile")")
            .toolbar {
                Button {
                    print("DEbuG: Edit account")
                } label: {
                    Text("edit")
                }
                Button {
                    showingLogOut = true
                } label: {
                    Text("Log out")
                        .foregroundColor(.black)
                        .bold()
                }
            }
            .alert("Are you sure you would like to log out", isPresented: $showingLogOut) {
                Button("Yes", role: .cancel) {
                    // ... logout
                }
            }
        }
        
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
