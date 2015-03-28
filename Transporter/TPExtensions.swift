//
//  TPExtensions.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import UIKit

extension UIDevice {
    private class var osVersion: NSString {
        return UIDevice.currentDevice().systemVersion
    }
    
    class func systemVersionEqualTo(version: NSString) -> Bool {
        return osVersion.compare(version, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    class func systemVersionGreaterThan(version: NSString) -> Bool {
        return osVersion.compare(version, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    class func systemVersionGreaterThanOrEqualTo(version: NSString) -> Bool {
        return osVersion.compare(version, options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    class func systemVersionLessThan(version: NSString) -> Bool {
        return osVersion.compare(version, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    class func systemVersionLessThanOrEqualTo(version: NSString) -> Bool {
        return osVersion.compare(version, options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
}