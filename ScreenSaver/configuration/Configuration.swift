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
    let baseSpeed: Double = 0.5     // time multiplier for middle disc
    let sceneScale: Scalar  = 0.875 // in percent of smaller screen dimension
    let spriteScale: Scalar = 0.80  // in percent of grid size

    private var defaults: UserDefaults

    var backgroundColor = NSColor.darkGray

    init()
    {
        let identifier = Bundle(for: Configuration.self).bundleIdentifier!
        defaults = ScreenSaverDefaults(forModuleWithName: identifier)! as UserDefaults
        defaults.register(defaults: [
            "wheelCount": 19,
            "rotationOffset": 0.01,
            "speedOffset": 0.2
            ])
        synchronize()
    }


    func synchronize()
    {
        defaults.synchronize()
    }


    // number of wheels along each dimension
    var wheelCount: Int
    {
        set {
            defaults.set(newValue, forKey: "wheelCount")
        }
        get {
            defaults.integer(forKey: "wheelCount")
        }
    }

    // rotational offset in percent of full rotation
    var rotationOffset: Double
    {
        set {
            defaults.set(newValue, forKey: "rotOffset")
        }
        get {
            defaults.double(forKey: "rotOffset")
        }
    }

    // spped offset from top to middle disc in percent
    var speedOffset: Double
    {
        set {
            defaults.set(newValue, forKey: "speedOffset")
        }
        get {
            defaults.double(forKey: "speedOffset")
        }
    }

    // multiplier for time (bottom, middle, top shape)
    var rotationSpeeds: [Double]
    {
        return [0, baseSpeed * (1 + speedOffset), baseSpeed]
    }



}

