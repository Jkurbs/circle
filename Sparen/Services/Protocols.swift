//
//  Protocols.swift
//  Sparen
//
//  Created by Kerby Jean on 9/20/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit


protocol DataProtocol {
    
    func fetchCurrentUser( complete: @escaping ( _ success: Bool, _ error: Error?, _ users: User )->() )
    
    func fetchUserInsights( _ userId: String, complete: @escaping ( _ success: Bool, _ error: Error?, _ daysTotal: Int, _ daysLeft: Int, _ position: Int )->())
    
    func fetchCurrentUserCircle( _ circleId: String?, complete: @escaping ( _ success: Bool, _ error: Error?, _ circle: Circle )->() )
    
    func createCircle(_ amount: Int, complete: @escaping ( _ success: Bool, _ error: Error?)->())
        
    func fetchCircleInsights( _ circleId: String?, complete: @escaping ( _ success: Bool, _ error: Error?, _ insight: Insight )->())
    
    func fetchMembers( complete: @escaping ( _ success: Bool, _ error: Error?, _ user: User )->())
    
    func findCircles ( complete: @escaping ( _ success: Bool, _ error: Error?, _ circle: Circle? )->())

    func saveToken ( _ state: Bool, _ token: String, _ circleId: String, complete: @escaping ( _ success: Bool, _ error: Error?)->())
    
    func joinCircle (_ circleId: String?, complete: @escaping ( _ success: Bool, _ error: Error?)->())
    
    func leaveCircle (_ circle: Circle, _ position: Int, complete: @escaping ( _ success: Bool, _ error: Error?)->())
    
//    func savePosition (_ circle: Circle, complete: @escaping ( _ success: Bool, _ error: Error? )->())

    
    func activateCircle(_ circle: Circle, complete: @escaping ( _ success: Bool, _ error: Error?) ->())
    
    func saveUserData(_ userId: String, _ data: [String: Any], complete: @escaping ( _ success: Bool, _ error: Error?) ->())
    
    func updateUserData ( _ username: String, _ fullname: [String], _ email: String, _ phone: String, _ image: UIImage, complete: @escaping ( _ success: Bool, _ error: Error?) ->())
    
    func findCircleMembers(_ circleId: String, complete: @escaping ( _ success: Bool, _ error: Error?, _ user: User, _ count: Int) ->())
    
    func addPayment(_ accounttoken: String, _ sourceToken: String, _ type: String, _ expirationDate: String, _ last4: String, _ prefix: String, complete: @escaping ( _ success: Bool, _ error: Error?) ->())
}


protocol AuthProtocol {
    
     func verifyPhone(_ phoneNumber: String, complete: @escaping ( _ success: Bool, _ error: Error?)->())
    
     func signIn( _ email: String, _ password: String, complete: @escaping (_ success: Bool, _ error: Error?, _ circleId: String?)->())
    
    func createAccount(_ firstName: String, _ lastName: String, _ email: String, _ phoneNumber: String, _ password: String, _ code: String, _ isAdmin: Bool, _ dateOfBirth: [String?], complete: @escaping ( _ success: Bool, _ error: Error?)->())
     
}














