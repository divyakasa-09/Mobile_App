//
//  AddUserView.swift
//  Swift_UI_App
//
//  Created by Divya Kasa on 11/19/23.
//


import SwiftUI

struct AddUserView: View {
    
    // create variables to store user input values
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var showAlert = false
    
    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.pink)
                .padding(10)
            VStack {
                
                // create name field
                TextField("Enter Full Name", text: $name)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                    .disableAutocorrection(true)
                
                // create email field
                TextField("Enter Email ID", text: $email)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // create age field, number pad
                TextField("Enter Age", text: $age)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))
                    .keyboardType(.numberPad)
                    .disableAutocorrection(true)
                
                // button to add a user
                Button(action: {
                    // Check if required fields are not empty
                    if !name.isEmpty && !email.isEmpty && !age.isEmpty {
                        // Call function to add row in SQLite database
                        DB_Manager().addUser(
                            nameValue: name,
                            emailValue: email,
                            ageValue: Int64(age) ?? 0
                        )
                        // Go back to the home page
                        self.mode.wrappedValue.dismiss()
                    } else {
                        // Show an alert if any required field is empty
                        showAlert = true
                    }
                }) {
                    Text("Add User")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.blue))
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all required fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
