//
//  Resources.swift
//
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation
import Unzip

let SW_MSG = false // Show message in this file
let FOLDER_NAME = ".Bressani.dev"

public class Resources {
    public var swDebug: Bool
    var bundle: URL?
    public var zipFile: String
    var unzipFile : UnzipFile?
    
    public init(zipFile: String) {
        self.swDebug = SW_MSG // Console info
        self.bundle = nil
        self.zipFile = zipFile
        self.unzipFile = nil
    }
    
    /// Load ressource
    public func load() -> Bool {
        if let b = Bundle.module.url(forResource: self.zipFile, withExtension: "zip") {
            self.bundle = b
            return true
        } else {
            return false
        }
    }
    
    /// Unzip ressource
    public func unzip() -> Bool {
        if self.bundle == nil {
            return false
        } else {
            let uF = UnzipFile(fileURL: self.bundle!, destinationFolder: FOLDER_NAME)
            if uF.unzip() == 0 {
                self.unzipFile = uF
                if SW_MSG {
                    print("Unzip with success !")
                }
                return true
            } else {
                return false
            }
        }
    }
    
    /// Get self.unzipFile
    public func getUnzip() -> UnzipFile? {
        return unzipFile
    }
}
