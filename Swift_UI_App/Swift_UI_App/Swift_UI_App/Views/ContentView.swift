//
//  ContentView.swift
//  Swift_UI_App
//
//  Created by Divya Kasa on 11/19/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var userModels: [UserModel] = []
    @State var userSelected: Bool = false
    @State var selectedUserId: Int64 = 0
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.pink)
                    .padding(5)
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: AddUserView(),
                            label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.blue)
                                    Text("Add User")
                                        .foregroundColor(Color.white)
                                        .padding(8)
                                }
                            }
                        ).frame(width: 100, height: 30)
                    }
                    
                    NavigationLink(
                        destination: EditUserView(id: self.$selectedUserId),
                        isActive: self.$userSelected
                    ) {
                        EmptyView()
                    }
                    
                    List(self.userModels) { (model) in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Name: \(model.name)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Email: \(model.email)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("Age: \(model.age)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    self.selectedUserId = model.id
                                    self.userSelected = true
                                }, label: {
                                    Text("Edit")
                                        .foregroundColor(Color.blue)
                                        .padding(8)
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    // Show a delete confirmation alert
                                    showAlert = true
                                }, label: {
                                    Text("Delete")
                                        .foregroundColor(Color.red)
                                        .padding(8)
                                })
                                .buttonStyle(PlainButtonStyle())
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Are you sure?"),
                                        message: Text("This action will permanently delete the user."),
                                        primaryButton: .destructive(Text("Delete")) {
                                            // Delete the user
                                            let dbManager: DB_Manager = DB_Manager()
                                            dbManager.deleteUser(idValue: model.id)
                                            self.userModels = dbManager.getUsers()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white))
                        .shadow(radius: 5)
                        .padding([.top, .bottom], 5)
                    }
                }
                .padding()
                .onAppear(perform: {
                    self.userModels = DB_Manager().getUsers()
                })
                .navigationBarTitle("Users")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
