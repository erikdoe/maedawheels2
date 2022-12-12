import Cocoa

class GridView : NSView {

    var path: NSBezierPath;

    init(configuration: Configuration, frame: NSRect)
    {
        let outputSize = Vector2(Scalar(frame.width), Scalar(frame.height))
        let sceneSize = min(outputSize.x, outputSize.y) * configuration.sceneScale
        let gridSize = sceneSize / Scalar(configuration.wheelCount)
        let wheelCount = configuration.wheelCount

        path = NSBezierPath()
        for i in 0...wheelCount {
            path.move(to: (Vector2(x: Scalar(0)         , y: Scalar(i)) * gridSize).toNSPoint)
            path.line(to: (Vector2(x: Scalar(wheelCount), y: Scalar(i)) * gridSize).toNSPoint)
            path.move(to: (Vector2(x: Scalar(i), y: Scalar(0))          * gridSize).toNSPoint)
            path.line(to: (Vector2(x: Scalar(i), y: Scalar(wheelCount)) * gridSize).toNSPoint)
        }

        let lowerLeft = (outputSize - Vector2(sceneSize)) / 2
        path.transform(using: AffineTransform(translationByX: CGFloat(lowerLeft.x), byY: CGFloat(lowerLeft.y)))

        super.init(frame: frame)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: NSRect)
    {
        super.draw(rect)
        NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.1, alpha: 1).set()
        path.lineWidth = 1
        path.stroke()
    }

}

extension Vector2
{
    public var toNSPoint: NSPoint
    {
        NSMakePoint(CGFloat(x), CGFloat(y))
    }
}
