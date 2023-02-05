//
//  OrderCardView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/13/23.
//

import SwiftUI

struct OrderCardView: View {
    @State var id: String = ""
    @State var total: Float64 = 0
    @State var orderStatus: Int = 0
    @State private var changingStatus: Bool = false
    @EnvironmentObject var orderManager: OrderManager
    
    @State var savedStatus: Int = 0
    @State var onUpdate: Bool = false
    
    let status: [Int: String] = [
        0: "Received",
        1: "Preparing",
        2: "Ready",
        3: "Queued",
        4: "Delivered"
    ]
    
    var body: some View {
        HStack {
            Image("food2")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(8)
            VStack(spacing: 0) {
                Group {
                    
                    Text("\(id)")
                        .font(.headline)
                    Text("$\(total, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(Color.secondary)
//                                    Text("\(status[order.status]!)")
//                                        .font(.subheadline)
//                                        .foregroundColor(Color.secondary)
                        .padding(.bottom, 8)
                    HStack {
                        Picker(selection: $savedStatus, label: Text("Picker here")) {
                            Text("\(status[0]!)")
                                .tag(0)
                            Text("\(status[1]!)")
                                .tag(1)
                            Text("\(status[2]!)")
                                .tag(2)
                        }
                        
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 115)
                        .background(Color("cartIcon"))
                        .shadow(color: Color("cartIcon").opacity(0.2), radius: 10, x: 0, y: 5)
                        .bold()
                        .cornerRadius(5)
                        .accentColor(Color.white)
                        
                        if (self.savedStatus != orderStatus) {
                            
                            Button {
                                
                                print("ORDER: Update order!")
                                self.onUpdate = true
//                                Task {
//                                    print("DEBUG: TESTING TASk")
//
//                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(.secondary)
                                        .opacity(0.12)
                                        .frame(width: 34, height: 34)
                                    Image(systemName: "arrow.down")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(maxWidth: 15, maxHeight: 20, alignment: .leading)
                                        .font(.largeTitle)
                                    
                                }
                                .shadow(color: Color.secondary.opacity(0.3), radius: 10, x: 0, y: 5)
                                .padding(.leading, 8)
                                
                            }
                            if self.onUpdate {
                                Text("Updated")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                                    
                                    .onAppear {
                                        orderManager.updateStatus(orderId: self.id, newStatus: self.savedStatus)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.onUpdate = false
                                            orderStatus = self.savedStatus
                                        }
                                    }
                            }
                        }
                        
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 4)
            
        }
        .onAppear {
            self.savedStatus = orderStatus
        }
        .onChange(of: orderStatus, perform: { newValue in
            print("STATUS: new value: \(newValue)")
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                        .background(.pink)
        .padding(.leading)
        Divider()
    }
}

struct OrderCardView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCardView()
    }
}
