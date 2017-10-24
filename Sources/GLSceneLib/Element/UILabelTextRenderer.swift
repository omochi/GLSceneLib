#if os(iOS)
    import UIKit
    
    public class UILabelTextRenderer : TextRenderer {
        public init(label: UILabel,
                    destructor: @escaping () -> Void)
        {
            self.label = label
            self.destructor = destructor
        }
        
        deinit {
            destructor()
        }
        
        public let label: UILabel
        
        
        public func updateVisible(_ value: Bool) {
            label.isHidden = !value
        }
        
        public func updateText(_ text: String) {
            label.text = text
            label.sizeToFit()
        }
        
        public func updateColor(_ color: Color) {
            label.textColor = color.toUIColor()
        }
        
        public func render(position: Vector3,
                           renderer: SceneRenderer)
        {
            var frame = label.frame
            frame.origin = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
            label.frame = frame
        }
        
        private let destructor: () -> Void
    }
    
#endif
