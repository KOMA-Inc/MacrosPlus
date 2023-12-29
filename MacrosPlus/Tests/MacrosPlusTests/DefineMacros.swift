import Foundation
import SwiftSyntaxMacros

#if canImport(Macros)
import Macros

let testMacros: [String: Macro.Type] = [
  "URL": URLMacro.self
]
#endif
