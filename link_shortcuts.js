#!/usr/bin/env node
const getProject = require("./lib/getProject");
const glob = require("glob");
const plist = require("plist");
var path = require("path");
var fs = require("fs");

const p = getProject();
const shortcuts = p.shortcuts;

//Now get the plist
var g = path.join(process.cwd(), "ios", "*", "Info.plist");
const plists = glob.sync(g);
plists.forEach(pa => {
  const source = fs.readFileSync(pa, "utf8");
  var o = plist.parse(source);
  var sc = o.UIApplicationShortcutItems;
  if (!p.shortcuts) {
    if (typeof sc !== "undefined") {
      delete o.UIApplicationShortcutItems;
      console.log("Removed all shortcuts from project");
      return;
    } else {
      console.log("Shortcut list was already blank - no change");
    }
  } else {
    //rebuild my target sc
    o.UIApplicationShortcutItems = Object.keys(p.shortcuts).map(key => {
      const obj = p.shortcuts[key];
      var sobj = {
        UIApplicationShortcutItemType: key,
        UIApplicationShortcutItemTitle: obj.label
      };
      if (obj.icontype) {
        sobj.UIApplicationShortcutItemIconType = obj.icontype;
      }
      return sobj;
    });
  }
  const xml = plist.build(o);
  fs.writeFileSync(pa, xml);
});
