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

class Shape
{
    static let bottomDisc: Shape = {
        let p = NSBezierPath(ovalIn: NSMakeRect(0.02, 0.02, 0.96, 0.96));
        let c = NSColor.white
        return Shape(fill: p, stroke: nil, color: c)
    }()

    static let middleDisc: Shape = {
        let p = makeQuartersPath()
        let c = NSColor(calibratedRed: 0.667, green: 0.2, blue: 0.2, alpha: 1)
        return Shape(fill: p, stroke: nil, color: c)
    }()

    static let topDisc: Shape = {
        let pf = makeQuartersPath()
        let ps = NSBezierPath(ovalIn: NSMakeRect(0.00, 0.00, 1.00, 1.00));
        let c  = NSColor.black
        return Shape(fill: pf, stroke: ps, color: c)
    }()

    private static func makeQuartersPath() -> NSBezierPath
    {
        let p = NSBezierPath();
        p.move(to: NSMakePoint(0.50, 0.50))
        p.line(to: NSMakePoint(0.98, 0.50))
        p.appendArc(withCenter: NSMakePoint(0.50, 0.50), radius: 0.48, startAngle: 0, endAngle: 90)
        p.line(to: NSMakePoint(0.5, 0.02))
        p.appendArc(withCenter: NSMakePoint(0.50, 0.50), radius: 0.48, startAngle: 270, endAngle: 180, clockwise: true)
        p.close()
        return p
    }


    private let fillPath: NSBezierPath
    private let strokePath: NSBezierPath?
    private let color: NSColor

    init(fill: NSBezierPath, stroke: NSBezierPath?, color: NSColor)
    {
        self.fillPath = fill
        self.strokePath = stroke
        self.color = color
    }

    func makeBitmap(size: CGFloat) -> NSBitmapImageRep
    {
        let imageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size), bitsPerSample: 8,
                                        samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB,
                                        bytesPerRow: Int(size)*4, bitsPerPixel:32)!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: imageRep)

        let scaledFillPath = fillPath.copy() as! NSBezierPath
        scaledFillPath.transform(using: AffineTransform(scaleByX: size, byY: size))
        color.set()
        scaledFillPath.fill()

        if let strokePath = strokePath {
            let shrinkFactor: CGFloat = 0.03
            let scaledStrokePath = strokePath.copy() as! NSBezierPath
            scaledStrokePath.transform(using: AffineTransform(scaleByX: size * (1 - shrinkFactor), byY: size * (1 - shrinkFactor)))
            scaledStrokePath.transform(using: AffineTransform(translationByX: size * shrinkFactor/2, byY: size * shrinkFactor/2))
            scaledStrokePath.lineWidth = size * 0.03
            color.set()
            scaledStrokePath.stroke()
        }

        NSGraphicsContext.restoreGraphicsState()
        return imageRep
    }

}
