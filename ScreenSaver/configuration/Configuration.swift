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

class Configuration
{
    static let sharedInstance = Configuration()

    let wheelCount = 19            // num of wheels along a dimension
    let rotSpeeds = [0, 0.6, 0.5]  // multiplier for time (bottom, middle, top shape)
    let rotIncrement = 0.04        // value to add to rotation to next wheel
    let sceneScale: Scalar  = 0.88 // in percent of smaller screen dimension
    let spriteScale: Scalar = 0.80 // in percent of grid size
    let lineWidth: Scalar   = 0.03 // in percent of shape size

    private var defaults: UserDefaults

    var backgroundColor = NSColor.darkGray

    init()
    {
        let identifier = Bundle(for: Configuration.self).bundleIdentifier!
        defaults = ScreenSaverDefaults(forModuleWithName: identifier)! as UserDefaults
        defaults.register(defaults: [
            "tiles": 25,
            ])
        update()
    }

    private static func loadPalettes() -> [[String]]
    {
        let url = Bundle(for: Configuration.self).url(forResource: "Colors", withExtension: "json")!
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonResult as! [[String]]
        } catch {
            NSLog("Error loading 'Colors.json'")
            return []
        }
    }

    var tiles: Int
    {
        set {
            defaults.set(newValue, forKey: "tiles")
        }
        get {
            defaults.integer(forKey: "tiles")
        }
    }

    private func update()
    {
        defaults.synchronize()
    }

    
}

