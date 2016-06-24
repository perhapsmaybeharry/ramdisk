//
//  ViewController.swift
//  RAMdisk
//
//  Created by Harry Wang on 27/4/16.
//  Copyright © 2016 thisbetterwork. All rights reserved.
//

import Cocoa
import SystemKit

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		var timer = NSTimer()
		timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.timertick), userInfo: nil, repeats: true)
		
	}
	func memoryUnit(value: Double) -> String {
		if value < 1.0 { return String(Int(value * 1000.0))    + " MB" }
		else           { return NSString(format:"%.2f", value) as String + " GB" }
	}
	func updateFreeRam() {
		freeram.stringValue = memoryUnit(System.memoryUsage().free)
	}
	func checkIfRamdiskSizeExceedsFreeRam(ramdiskSize: Double, freeRam: Double) -> Bool {
		if ramdiskSize >= freeRam {return true}
		else {return false}
	}
	
	func timertick() {
		updateFreeRam()
		if checkIfRamdiskSizeExceedsFreeRam(understandSuffix(suffix.titleOfSelectedItem!, value: size.doubleValue)/1000000000, freeRam: System.memoryUsage().free) {
			createbutton.enabled = false
		}
		else {createbutton.enabled = true}
	}
	
	@IBOutlet var label: NSTextField!
	
	@IBOutlet var size: NSTextField!
	@IBOutlet var suffix: NSPopUpButton!
	
	@IBOutlet var freeram: NSTextField!
	
	@IBOutlet var createbutton: NSButton!
	@IBAction func create(sender: NSButton) {
		
		let make = NSTask()
		make.launchPath = "/bin/bash"
		make.arguments = ["-c", "diskutil eraseVolume HFS+ \(label.stringValue) `hdiutil attach -nomount ram://\(computeInto512ByteCount(understandSuffix(suffix.titleOfSelectedItem!, value: size.doubleValue)))`"]
		make.launch()
		make.waitUntilExit()
		
	}
	
	func computeInto512ByteCount(value: Double) -> Int {
		return Int(value/512)
	}
	
	func understandSuffix(suffix: String, value: Double) -> Double {
		if suffix == "bytes" {
			return value
		} else if suffix == "kilobytes" {
			return value*1000
		} else if suffix == "megabytes" {
			return value*1000000
		} else if suffix == "gigabytes" {
			return value*1000000000
		}
		return 0
	}

}

