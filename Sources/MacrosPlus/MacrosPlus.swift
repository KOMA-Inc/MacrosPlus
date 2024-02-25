import Foundation

@freestanding(expression)
public macro URL(_ string: String) -> URL = #externalMacro(module: "Macros", type: "URLMacro")

#if canImport(UIKit)
import UIKit

@freestanding(expression)
public macro UIImage(_ string: String) -> UIImage = #externalMacro(module: "Macros", type: "UIImageMacro")
#endif

#if canImport(AppKit)
import AppKit

@freestanding(expression)
public macro NSImage(_ string: String) -> NSImage = #externalMacro(module: "Macros", type: "NSImageMacro")
#endif

#if canImport(SwiftUI)
import SwiftUI

@freestanding(expression)
public macro Image(_ string: String) -> Image = #externalMacro(module: "Macros", type: "ImageMacro")
#endif
