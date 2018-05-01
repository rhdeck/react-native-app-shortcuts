import Foundation
import RNSRegistry
class RNShortcuts {
    public static var main:RNShortcuts = RNShortcuts()
    public func addShortcut(_ newShortcut: UIApplicationShortcutItem, callback: (Any)->Bool) -> Bool {
        _ = removeShortcut(newShortcut.type)
        let existingShortcuts = UIApplication.shared.shortcutItems ?? []
        var newShortcuts = existingShortcuts
        newShortcuts.append(newShortcut)
        UIApplication.shared.shortcutItems = newShortcuts
        _ = RNSMainRegistry.main.addEvent(type: "shortcut." + newShortcut.type, key: newShortcut.type, callback: callback)
        return true
    }
    public func removeShortcut(_ type:String) -> Bool {
        let existingShortcuts = UIApplication.shared.shortcutItems ?? []
        guard existingShortcuts.count > 0 else { return true }
        UIApplication.shared.shortcutItems = existingShortcuts.filter() { sc in
            if sc.type == type {
                RNSMainRegistry.main.removeEvent(type: "shortcut." + type, key: type)
                return false
            }
            return true
        }
        return true
    }
}
