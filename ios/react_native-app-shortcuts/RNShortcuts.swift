import Foundation
import RNSRegistry
class RNShortcuts {
    public static var main:RNShortcuts = RNShortcuts()
    public func addShortcut(_ newShortcut: UIApplicationShortcutItem, callback: @escaping (Any)->Bool) -> Bool {
        _ = removeShortcut(newShortcut.type)
        let existingShortcuts = UIApplication.shared.shortcutItems ?? []
        var newShortcuts = existingShortcuts
        newShortcuts.append(newShortcut)
        UIApplication.shared.shortcutItems = newShortcuts
        linkShortcut(type: "shortcut." + newShortcut.type, callback: callback)
        return true
    }
    public func linkShortcut(type:String, callback: @escaping (Any)->Bool) {
        let _ = RNSMainRegistry.main.addEvent(type: "shortcut." + type, key: type, callback: callback )
    }
    public func removeShortcut(_ type:String) -> Bool {
        let existingShortcuts = UIApplication.shared.shortcutItems ?? []
        guard existingShortcuts.count > 0 else { return true }
        UIApplication.shared.shortcutItems = existingShortcuts.filter() { sc in
            if sc.type == type {
                unlinkShortcut(type: type)
                return false
            }
            return true
        }
        return true
    }
    public func unlinkShortcut(type: String) {
        RNSMainRegistry.main.removeEvent(type: "shortcut." + type, key: type)
    }
}
