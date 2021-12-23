//
//  AppDelegate.swift
//  ScrcpyBar
//
//  Created by fatkhur1960 on 23/12/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var statusItem: NSStatusItem?
    var menu: NSMenu?
    var task: Process = Process()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "iphone.homebutton.badge.play", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonToggle)
            menuButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        menu = NSMenu(title: "Status Bar Menu")
        menu?.delegate = self
        menu?.addItem(
            withTitle: "Quit",
            action: #selector(closeApp),
            keyEquivalent: "")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if task.isRunning {
            task.terminate()
        }
    }
    
    @objc func menuButtonToggle(sender: NSStatusBarButton) {
        if let eventType = NSApp.currentEvent?.type {
            if eventType == NSEvent.EventType.rightMouseUp  {
                if let menu = menu {
                    statusItem?.menu = menu
                    statusItem?.button?.performClick(nil)
                }
            } else {
                if task.isRunning {
                    return
                }
                
                runWindow()
            }
        }
    }
    
    @objc func menuDidClose(_ menu: NSMenu) {
       statusItem?.menu = nil
    }
    
    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }
    
    func runWindow() {
        task = Process()
        task.environment = ["PATH": Bundle.main.resourcePath!]
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "scrcpy", "-S", "--stay-awake", "-m", "1080", "--always-on-top"]
        task.launch()
    }

}
