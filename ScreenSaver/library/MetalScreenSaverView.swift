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
import Metal
import IOKit.ps

class MetalScreenSaverView : ScreenSaverView
{
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!


    override init?(frame: NSRect, isPreview: Bool)
    {
        super.init(frame: frame, isPreview: isPreview)
        device = selectMetalDevice()
        wantsLayer = true;
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    private func selectMetalDevice() -> MTLDevice
    {
        var device: MTLDevice?
        var message: String
        
        if IOPSGetTimeRemainingEstimate() == kIOPSTimeRemainingUnlimited {
            device = MTLCreateSystemDefaultDevice()
            message = "Connected to power, using default video device"
        } else {
            message = "On battery, using video device"
            for d in MTLCopyAllDevices() {
                device = d
                if d.isLowPower && !d.isHeadless {
                    message = "On battery, using low power video device"
                    break
                }
            }
        }
        if let name = device?.name {
            NSLog("MetalScreenSaverView: \(message) \(name)")
        } else {
            NSLog("MetalScreenSaverView: No or unknown video device. Screen saver might not work.")
        }
        return device!
    }


    // deferred initialisations that require access to the window

    override func viewDidMoveToSuperview()
    {
        super.viewDidMoveToSuperview()
        if let window = superview?.window {
            metalLayer = makeMetalLayer(window: window, device:device)
            layer = metalLayer
        }
    }

    private func makeMetalLayer(window: NSWindow, device: MTLDevice) -> CAMetalLayer
    {
        let metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.contentsScale = window.backingScaleFactor
        metalLayer.isOpaque = true
        return metalLayer
    }


}

