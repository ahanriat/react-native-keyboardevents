'use strict';

var RCTDeviceEventEmitter = require('RCTDeviceEventEmitter');
var RNKeyboardEventsManager = require('NativeModules').RNKeyboardEventsManager;
var EventEmitter = require('eventemitter3');

var KeyboardEventEmitter = new EventEmitter();
var events = [
  'WillShow',
  'DidShow',
  'WillHide',
  'DidHide',
  'WillChangeFrame',
  'DidChangeFrame'
].map(function(event) {return 'Keyboard' + event});

events.forEach(function(eventKey) {
  var event = RNKeyboardEventsManager[eventKey];
  RCTDeviceEventEmitter.addListener(
    event,
    function(frames) {
      KeyboardEventEmitter.emit(event, frames);
    }
  );
});

module.exports = events.reduce(function(carry, eventKey) {
  carry[eventKey + 'Event'] = RNKeyboardEventsManager[eventKey];
  return carry;
},{
  Emitter: KeyboardEventEmitter
});
