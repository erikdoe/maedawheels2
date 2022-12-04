/*
 *  Copyright 2016-2020 Erik Doernenburg
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License. You may obtain
 *  a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *  License for the specific language governing permissions and limitations
 *  under the License.
 */

import ScreenSaver

class ConfigureSheetController : NSObject
{
    static var sharedInstance = ConfigureSheetController()

    public var configuration: Configuration!
    
    @IBOutlet var window: NSWindow!
    @IBOutlet var versionField: NSTextField!
    @IBOutlet var wheelSlider: NSSlider!
    @IBOutlet var wheelField: NSTextField!
    @IBOutlet var rotationSlider: NSSlider!
    @IBOutlet var rotationField: NSTextField!
    @IBOutlet var speedSlider: NSSlider!
    @IBOutlet var speedField: NSTextField!

    override init()
    {
        super.init()

        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)

        let bundleVersion = (myBundle.infoDictionary!["CFBundleShortVersionString"] ?? "n/a") as! String
        let sourceVersion = (myBundle.infoDictionary!["Source Version"] ?? "n/a") as! String
        versionField.stringValue = String(format: "Version %@ (%@)", bundleVersion, sourceVersion)
    }
    

    @IBAction func openProjectPage(_ sender: AnyObject)
    {
        NSWorkspace.shared.open(URL(string: "https://github.com/erikdoe/maedawheels2")!);
    }

    @IBAction func closeConfigureSheet(_ sender: NSButton)
    {
        if sender.tag == 1 {
            saveConfiguration()
        }
        window.sheetParent!.endSheet(window, returnCode: (sender.tag == 1) ? NSApplication.ModalResponse.OK : NSApplication.ModalResponse.cancel)
    }

    @IBAction func updateValues(_ sender: AnyObject)
    {
        wheelField.stringValue = String(format:"%d×%d", wheelSlider.intValue, wheelSlider.intValue)
        rotationField.stringValue = String(format:"%.0f%%", rotationSlider.floatValue * 100)
        speedField.stringValue = String(format:"%.0f%%", speedSlider.floatValue * 100)
    }


    func loadConfiguration()
    {
        wheelSlider.integerValue = configuration.wheelCount
        rotationSlider.doubleValue = configuration.rotationOffset
        speedSlider.doubleValue = configuration.speedOffset
        updateValues(self)
    }

    private func saveConfiguration()
    {
        configuration.wheelCount = wheelSlider.integerValue
        configuration.rotationOffset = rotationSlider.doubleValue
        configuration.speedOffset = speedSlider.doubleValue
        configuration.synchronize()
    }

}
