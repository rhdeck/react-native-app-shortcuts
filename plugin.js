const saveProject = require("./lib/saveProject");
const getProject = require("./lib/getProject");
const cp = require("child_process");

function updateNative() {
  cp.spawnSync("node", ["node_modules/.bin/link_shortcuts"], {
    stdio: "inherit"
  });
}
module.exports = [
  {
    name: "addshortcut <key> [label]",
    options: [
      {
        command: "--label [label]",
        description: "Label for the shortcut"
      },
      {
        command: "--icontype [type]",
        description:
          "Icon Type (specified in list https://developer.apple.com/documentation/uikit/uiapplicationshortcuticontype?language=objc)"
      }
    ],
    description: "Add specified shortcut",
    func: (key, obj, args) => {
      if (typeof key !== "string") {
        var label = key[1] ? key[1] : key[0];
        var key = key[0];
      }
      var p = getProject();
      var shortcutinfo = { label: label };
      if (args && args.label) shortcutinfo.label = args.label;
      if (args && args.icontype) shortcutinfo.icontype = args.icontype;
      if (!p.shortcuts) p.shortcuts = {};
      p.shortcuts[key] = shortcutinfo;
      saveProject(p);
      updateNative();
    }
  },
  {
    name: "removeshortcut <key>",
    description: "Remove shortcut with specified key",
    func: key => {
      if (typeof key !== "string") key = key[0];
      if (!key) {
        console.log("No key specified");
        return;
      }
      var p = getProject();
      if (!p.shortcuts[key]) {
        console.log("No shortcut called " + key);
      } else {
        delete p.shortcuts[key];
        if (!Object.keys(p.shortcuts)) delete p.shortcuts;
        saveProject(p);
        updateNative();
      }
    }
  },
  {
    name: "listshortcuts",
    description: "List all shortcuts",
    func: () => {
      var p = getProject();
      if (!p.shortcuts) {
        console.log("There are no shortcuts here");
      } else {
        console.log(JSON.stringify(p.shortcuts, null, 2));
      }
    }
  },
  {
    name: "clearshortcuts",
    description: "Remove all application shortcuts",
    func: () => {
      var p = getProject();
      if (!p.shortcuts) {
        console.log("There are no shortcuts here");
      } else {
        delete p.shortcuts;
        saveProject(p);
        console.log("Shortcuts deleted");
        updateNative();
      }
    }
  }
];
