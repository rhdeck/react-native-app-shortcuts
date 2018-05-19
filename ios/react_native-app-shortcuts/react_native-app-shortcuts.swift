import Foundation
import RNSRegistry
@objc(react_native_app_shortcuts)
class react_native_app_shortcuts: RCTEventEmitter {
    override init() {
        super.init()
        let _ = RNSMainRegistry.main.addEvent(type: "shortcut.app.reset", key: "resetBundle") { data in
            if RNSMainRegistry.main.triggerEvent("app.reset", data: data) {
                RNSMainRegistry.main.data.removeValue(forKey: "shortcuttriggered")
                //RNSMainRegistry.main.data.removeValue(forKey: "shortcut.app.reset")
            }
            return true
        }
    }
    //Demonstrate a basic promise-based function in swift
    @objc func addShortcut(_ key:String, label: String, icon: String?, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        let newShortcut = UIMutableApplicationShortcutItem(type: key, localizedTitle: label)
        if let i = icon {
            if let si = iconList[i] {
                newShortcut.icon = UIApplicationShortcutIcon(type: si)
            } else {
                //@TODO Look for the file reference? 
            }
        }
        _ = RNShortcuts.main.addShortcut(newShortcut) { data in
            self.sendEvent(withName: "react_native-app-shortcuts", body: [
                "type": key,
                "data": data
            ])
            return true
        }
        success(key);
    }
    @objc func removeShortcut(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        _ = RNShortcuts.main.removeShortcut(key)
        success(key)
    }
    @objc func linkShortcut(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNShortcuts.main.linkShortcut(type: key) { data in
            self.sendEvent(withName: "react_native-app-shortcuts", body: [
                "type": key,
                "data": data
            ])
            return true
        }
        success(key)
    }
    @objc func unlinkShortcut(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNShortcuts.main.unlinkShortcut(type: key)
        success(key)
    }
    //Note that any event name used in sendEvent above needs to be in this array.
    override func supportedEvents() -> [String]! {
        return ["react_native-app-shortcuts"]
    }
    //Demonstrate setting constants. Note that constants can be (almost) any type, but that this function is only evaluated once, at initialidation
    let iconList = [
        "add": UIApplicationShortcutIconType.add,
        "alarm": UIApplicationShortcutIconType.alarm,
        "audio": UIApplicationShortcutIconType.audio,
        "bookmark": UIApplicationShortcutIconType.bookmark,
        "capturePhoto": UIApplicationShortcutIconType.capturePhoto,
        "captureVideo": UIApplicationShortcutIconType.captureVideo,
        "cloud": UIApplicationShortcutIconType.cloud,
        "compose": UIApplicationShortcutIconType.compose,
        "confirmation": UIApplicationShortcutIconType.confirmation,
        "date": UIApplicationShortcutIconType.date,
        "favorite": UIApplicationShortcutIconType.favorite,
        "home": UIApplicationShortcutIconType.home,
        "invitation": UIApplicationShortcutIconType.invitation,
        "location": UIApplicationShortcutIconType.location,
        "love":UIApplicationShortcutIconType.love,
        "mail": UIApplicationShortcutIconType.mail,
        "markLocation": UIApplicationShortcutIconType.markLocation,
        "message": UIApplicationShortcutIconType.message,
        "pause": UIApplicationShortcutIconType.pause,
        "play": UIApplicationShortcutIconType.play,
        "prohibit": UIApplicationShortcutIconType.prohibit,
        "search": UIApplicationShortcutIconType.search,
        "share": UIApplicationShortcutIconType.share,
        "shuffle": UIApplicationShortcutIconType.shuffle,
        "task": UIApplicationShortcutIconType.task,
        "taskCompleted": UIApplicationShortcutIconType.taskCompleted,
        "time": UIApplicationShortcutIconType.time,
        "update": UIApplicationShortcutIconType.update
    ]
    @objc override func constantsToExport() -> Dictionary<AnyHashable, Any> {
        return [
            "icons": iconList.keys
        ];
    }
    override class func requiresMainQueueSetup() -> Bool {
        return true;
    }
}
