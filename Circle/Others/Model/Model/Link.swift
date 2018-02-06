//
//  Link.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class Link {
    
    var link = "Link Value"
    var source = "Source"
    var medium = "Medium"
    var campaign = "Campaign"
    var term = "Term"
    var content = "Content"
    var bundleID = "App Bundle ID"
    var fallbackURL = "Fallback URL"
    var minimumAppVersion = "Minimum App Version"
    var customScheme = "Custom Scheme"
    var iPadBundleID = "iPad Bundle ID"
    var iPadFallbackURL = "iPad Fallback URL"
    var appStoreID = "AppStore ID"
    var affiliateToken = "Affiliate Token"
    var campaignToken = "Campaign Token"
    var providerToken = "Provider Token"
    var packageName = "Package Name"
    var androidFallbackURL = "Android Fallback URL"
    var minimumVersion = "Minimum Version"
    var title = "Title"
    var descriptionText = "Description Text"
    var imageURL = "Image URL"
    var otherFallbackURL = "Other Platform Fallback URL"
    
    var identifier: String?
    var givenName: String?
    var namePrefix: String?
    var familyName: String?
    var emailAddress: String?
    var phoneNumber: String?
    var imageData: Data?
    
    init(data: Dictionary<String, AnyObject>) {

        
        
        
    }
}
