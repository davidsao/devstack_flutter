import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    flutterViewController.backgroundColor = .clear
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y, width: 1280, height: 720), display: true)
    self.minSize = NSSize(width: 640, height: 640)
    
    // 1. Extend the Flutter view into the title bar area
    self.styleMask.insert(.fullSizeContentView)
    
    // 2. Hide the default title text and background
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    
    // 3. Remove the subtle separator line under the title bar (macOS 11+)
    if #available(macOS 11.0, *) {
        self.titlebarSeparatorStyle = .none
    }
    self.backgroundColor = NSColor.windowBackgroundColor
    
    // 4. Add an invisible toolbar.
    // This natively pads the top area and pushes the traffic lights down.
    let customToolbar = NSToolbar()
    customToolbar.showsBaselineSeparator = false
    self.toolbar = customToolbar
      
    self.backgroundColor = NSColor.windowBackgroundColor
    
    // ---------------------------------------------------

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
