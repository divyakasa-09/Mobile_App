//
//  EditUserView.swift
//  Swift_UI_App
//
//  Created by Divya Kasa on 11/19/23.
//

import SwiftUI

struct EditUserView: View {
     
    // id receiving of user from the previous view
    @Binding var id: Int64
    
    // variables to store values from input fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var showAlert = false
    
    // to go back to the previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.pink)
                .padding(10)
            VStack {
                // create name field
                Text("Enter Full Name")
                    .foregroundColor(Color.white)
                    .font(.system(size:15))
                TextField("Enter Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                
                // create email field
                Text("Enter Email")
                    .foregroundColor(Color.white)
                    .font(.system(size:15))

                TextField("Enter Email ID", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .keyboardType(.emailAddress)
                
                // create age field, number pad
                Text("Enter Age")
                    .foregroundColor(Color.white)
                    .font(.system(size:15))

                TextField("Enter Age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .keyboardType(.numberPad)
                
                // button to update user
                Button(action: {
                    // Check if required fields are not empty
                    if !name.isEmpty && !email.isEmpty && !age.isEmpty {
                        // call function to update row in SQLite database
                        DB_Manager().updateUser(
                            idValue: self.id,
                            nameValue: self.name,
                            emailValue: self.email,
                            ageValue: Int64(self.age) ?? 0)
                        
                        // go back to home page
                        self.mode.wrappedValue.dismiss()
                    } else {
                        // Show an alert if any required field is empty
                        showAlert = true
                    }
                }) {
                    Text("Edit User")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.blue))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Please fill in all required fields."),
                dismissButton: .default(Text("OK"))
            )
        }
        // populate user's data in fields when view loaded
        .onAppear(perform: {
            // get data from the database
            let userModel: UserModel = DB_Manager().getUser(idValue: self.id)
            
            // populate in text fields
            self.name = userModel.name
            self.email = userModel.email
            self.age = String(userModel.age)
        })
    }
}

struct EditUserView_Previews: PreviewProvider {
    
    // when using @Binding, do this in the preview provider
    @State static var id: Int64 = 0
    
    static var previews: some View {
        EditUserView(id: $id)
    }
}
