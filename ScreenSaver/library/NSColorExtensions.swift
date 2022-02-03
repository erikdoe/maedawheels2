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

import Cocoa
import Metal

extension NSColor
{
    convenience init(webcolor: NSString)
    {
        var red:   Double = 0; Scanner(string: "0x"+webcolor.substring(with: NSMakeRange(1, 2))).scanHexDouble(&red)
        var green: Double = 0; Scanner(string: "0x"+webcolor.substring(with: NSMakeRange(3, 2))).scanHexDouble(&green)
        var blue:  Double = 0; Scanner(string: "0x"+webcolor.substring(with: NSMakeRange(5, 2))).scanHexDouble(&blue)
        self.init(red: CGFloat(red/256), green: CGFloat(green/256), blue: CGFloat(blue/256), alpha: 1)
    }

    func lighter(_ amount :CGFloat = 0.15) -> NSColor
    {
        hueColorWithBrightnessAmount(amount)
    }

    func darker(_ amount :CGFloat = 0.15) -> NSColor
    {
        hueColorWithBrightnessAmount(-amount)
    }

    fileprivate func hueColorWithBrightnessAmount(_ amount: CGFloat) -> NSColor
    {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness*(1+amount), alpha: alpha)
    }

    func toMTLClearColor() -> MTLClearColor
    {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let deviceColor = self.usingColorSpace(NSColorSpace.deviceRGB)
        deviceColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return MTLClearColor(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
    
    
}

