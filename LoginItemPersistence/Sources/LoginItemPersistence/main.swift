import Foundation
import Cocoa

//usage: ./LoginItemPersistence [app path] [true/false]
let fileMan = FileManager.default
let scriptName = CommandLine.arguments[0]

if CommandLine.arguments.count != 3 {
    print("Usage: \(scriptName) [path_to_app] [login_item_display_name] [true/false]")
    print("Note: the true/false option is for whether or not you want your login item hidden")
    exit(0)
}
else {
    if fileMan.fileExists(atPath: CommandLine.arguments[1]){
        let app = CommandLine.arguments[1]
        let hidden = CommandLine.arguments[2]
        let script =
        """
        tell application \"System Events\" to make login item at end with properties {path:\"\(app)",hidden:\(hidden)}
        """
        do {
            if let source = NSAppleScript(source: script){
                   var error : NSDictionary?
                   let result = source.executeAndReturnError(&error)
                   if let err = error {
                       print(err)
                   }
            }
        }
        catch let error {
            print("[-] \(error)")
        }
        
    }
    else {
        print ("[-] The app path that you entered does not exist")
        print("exiting...")
        exit(0)
    }
    
}
