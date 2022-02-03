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


class Sprite
{
    let shapeId: Int
    let pos: Vector2
    let cVectors: (Vector2, Vector2, Vector2, Vector2)
    let rotOffset: Double
    let rotSpeed: Double

    var didUpdate: Bool
    var corners: (Vector2, Vector2, Vector2, Vector2)

    init(shapeId: Int, position: Vector2, size: Vector2, rotOffset: Double, rotSpeed: Double)
    {
        self.shapeId = shapeId
        self.pos = position
        self.cVectors = (
            Vector2(+1, +1) * size/2,
            Vector2(+1, -1) * size/2,
            Vector2(-1, -1) * size/2,
            Vector2(-1, +1) * size/2
        )
        self.rotOffset = rotOffset
        self.rotSpeed = rotSpeed

        self.didUpdate = true
        self.corners = (Vector2(0), Vector2(0), Vector2(0), Vector2(0))
        updateCorners(rotation: 0)
    }

    var size: Vector2
    {
        get { cVectors.0 - cVectors.2 }
    }

    func animate(t now: Double)
    {
        didUpdate = false
        if rotSpeed > 0 {
            updateCorners(rotation: ((now - rotOffset) * rotSpeed))
            didUpdate = true
        }
    }

    private func updateCorners(rotation a: Double)
    {
        let sa = Scalar(sin(a))
        let ca = Scalar(cos(a))
        let r = Matrix2x2(ca, -sa, sa, ca)
        corners = (
            pos + cVectors.0 * r,
            pos + cVectors.1 * r,
            pos + cVectors.2 * r,
            pos + cVectors.3 * r
        )
    }
    
}
