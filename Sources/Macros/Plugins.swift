import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugins: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    URLMacro.self,
    ImageMacro.self,
    UIImageMacro.self,
    NSImageMacro.self
  ]
}
