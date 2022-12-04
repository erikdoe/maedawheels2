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


public class Scene
{
    let shapes: [Shape]
    let sprites: [Sprite]

    init(configuration config: Configuration, outputSize: Vector2)
    {
        shapes = [ Shape.bottomDisc, Shape.middleDisc, Shape.topDisc ]
        sprites = Scene.makeSprites(config: config, outputSize: outputSize)
    }

    private static func makeSprites(config: Configuration, outputSize: Vector2) -> [Sprite]
    {
        let sceneSize = min(outputSize.x, outputSize.y) * config.sceneScale
        let gridSize = sceneSize / Scalar(config.wheelCount)
        let spriteSize = gridSize * config.spriteScale
        let lowerLeft = (outputSize - Vector2(sceneSize)) / 2

        var sprites: [Sprite] = []
        // It's important that the shape loop is the outer loop because that results in the sprites being
        // ordered by their texture, which helps the renderer.
        for i in 0..<3 {
            var rotOffsetPercent: Double = 0
            for y in 0..<config.wheelCount {
                for x in 0..<config.wheelCount {
                    // We're adding 1/2 grid size because the sprites are drawn with (0, 0) as the centre.
                    let p = lowerLeft + Vector2(x: Scalar(x), y: Scalar(y)) * gridSize + Vector2(gridSize/2)
                    let actualRotOffset = (rotOffsetPercent + (((y * config.wheelCount + x) % 2 == 0) ? 0 : 0.5)) * 2 * .pi
                    let sprite = Sprite(shapeId: i, position: p, size: Vector2(x: spriteSize, y: spriteSize), rotOffset: actualRotOffset, rotSpeed:config.rotationSpeeds[i])
                    sprites.append(sprite)
                    rotOffsetPercent += config.rotationOffset
                }
            }
        }
        return sprites
    }

    var spriteSize: Vector2?
    {
        // all sprites have the same size
        get { sprites.first?.size }
    }

    func animate(t now: Double)
    {
        sprites.forEach({ $0.animate(t: now) })
    }
    
}
