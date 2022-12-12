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


@objc(MaedaWheels2View)
class MaedaWheels2View: MetalScreenSaverView
{
    var configuration: Configuration!
    var scene: Scene!
    var renderer: Renderer!

    override init?(frame: NSRect, isPreview: Bool)
    {
        configuration = Configuration()
        super.init(frame: frame, isPreview: isPreview)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }


    // configuration

    override var hasConfigureSheet: Bool
    {
        return true
    }

    override var configureSheet: NSWindow?
    {
        let controller = ConfigureSheetController.sharedInstance
        controller.configuration = configuration
        controller.loadConfiguration()
        return controller.window
    }


    // start and stop
    
    override func startAnimation()
    {
        let divisor = max(bounds.size.width, bounds.size.height)

        let outputSize = Vector2(Scalar(bounds.size.width), Scalar(bounds.size.height)) / Scalar(divisor)
        scene = Scene(configuration: configuration, outputSize: outputSize)

        renderer = Renderer(device: device, numTextures: scene.shapes.count, numQuads: scene.sprites.count)
        renderer.backgroundColor = configuration.backgroundColor.toMTLClearColor()
        renderer.setOutputSize(NSMakeSize(bounds.size.width / divisor, bounds.size.height / divisor))
        let widthInPixel = floor(bounds.width * CGFloat(scene.spriteSize!.x))
        let hidpiFactor = window!.backingScaleFactor
        for (i, shape) in scene.shapes.enumerated() {
            let bitmap = shape.makeBitmap(size: widthInPixel * hidpiFactor)
            renderer.setTexture(image: bitmap, at: i)
        }

        addSubview(GridView(configuration: configuration, frame: bounds))

        super.startAnimation()
    }

    override func stopAnimation()
    {
        super.stopAnimation()
        subviews[0].removeFromSuperview()
        renderer = nil
        scene = nil
    }

    
    // animation

    override func animateOneFrame()
    {
        scene.animate(t: CACurrentMediaTime())
        drawFrame()
    }
    
    private func drawFrame()
    {
        let sprites = scene.sprites
        let num = sprites.count
        var idx = 0
        while (idx < num) {
            let sprite = sprites[idx]
            renderer.updateQuad(sprite.corners, textureId: sprite.shapeId, at:idx)
            idx += 1
        }
        renderer.finishUpdatingQuads()

        if let drawable = metalLayer.nextDrawable() { // TODO: can this really happen?
            renderer.renderFrame(drawable: drawable)
        }

    }
    
}
