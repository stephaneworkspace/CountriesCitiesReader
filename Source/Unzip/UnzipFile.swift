//
//  UnzipFile.swift
//
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation
import Zip

let SW_MSG = false // Show message in this file

public class UnzipFile {
    public var swDebug: Bool
    public var fileURL: URL
    public var destinationFolder: String
    private var destinationURL: URL
    
    public init(fileURL: URL, destinationFolder: String) {
        self.swDebug = SW_MSG // Console info
        self.fileURL = fileURL
        self.destinationFolder = destinationFolder
        self.destinationURL = URL(string: "./")! // Initialize
    }
    
    /// Unzip datas
    ///
    ///  Return
    ///     0 : OK
    ///    -1 : Fail
    public func unzip() -> Int {
        do {
            // Define the destination path
            self.destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.destinationFolder)
            
            // Create the destination path if it doesn't exist
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            
            // Extract
            try Zip.unzipFile(fileURL, destination: destinationURL, overwrite: true, password: nil, fileOutputHandler:  { (progress) -> () in
                if self.swDebug {
                    print("Unziping in progress : \(progress)")
                }
            })
            return 0
        } catch {
            if self.swDebug {
                print("Error while unziping : \(error)")
            }
            return -1
        }
    }
    
    /// Get URL of the path unziped
    public func getURL() -> URL {
        return self.destinationURL
    }
    
    /// Get String of the URL of the path unziped
    public func getString(swFile: Bool) -> String {
        var urlString = self.destinationURL.absoluteString
        if !swFile {
            if urlString.hasPrefix("file://") {
                urlString.removeFirst("file://".count)
            }
        }
        return urlString
    }
    
    /// Get the Pointer of the URL of the path unziped
    public func getPtr() -> UnsafeMutablePointer<Int8>? {
        let urlString = self.getString(swFile: false)
        guard let cString = (urlString as NSString).utf8String else { return nil }
        let length = strlen(cString)
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: length + 1)
        buffer.initialize(from: cString, count: length + 1)
        return buffer
    }
    
    /// Free pointer
    public func freePtr(ptr: UnsafeMutablePointer<Int8>?) {
        ptr?.deallocate()
    }
}
