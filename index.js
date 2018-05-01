import { NativeModules, NativeEventEmitter } from "react-native";
const RNAS = NativeModules.react_native_app_shortcuts;
var isListening = false;
var nlistener = null;
var listeners = {};
const listener = (type, data) => {
  const l = listeners[type];
  if (l) l(data);
};
const startListening = () => {
  if (!isListening) {
    nlistener = NativeEventEmitter.addListener(
      "react_native-app-shortcuts",
      listener
    );
  }
};
const stopListening = () => {
  if (nlistener) nlistener.removeListener();
};
const checkListeners = () => {
  if (Object.keys(listeners).length == 0) {
    stopListening();
  }
};
const addShortcut = async (key, label, icon, cb) => {
  if (typeof icon == "function") {
    cb = icon;
    icon = null;
  }
  await RNAS.addShortcut(key, label, icon);
  linkShortcut(key, cb);
};
const removeShortcut = async key => {
  unlinkShortcut(key);
  return await RNAS.removeShortcut(key);
};
const linkShortcut = (key, cb) => {
  listeners[key] = cb;
  startListening();
};
const unlinkShortcut = key => {
  delete listeners[key];
  checkListeners();
};
export {
  addShortcut,
  removeShortcut,
  linkShortcut,
  unlinkShortcut,
  stopListening
};
