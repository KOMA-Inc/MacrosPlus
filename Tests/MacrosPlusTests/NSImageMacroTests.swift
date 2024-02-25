import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import MacrosPlus

#if canImport(Macros)
import Macros

private let testMacros: [String: Macro.Type] = [
    "NSImage": NSImageMacro.self
]
#endif

#if canImport(AppKit)
import AppKit
#endif


final class NSImageMacroTests: XCTestCase {

    #if canImport(AppKit)
    func testUsage() {
        XCTAssertEqual(#NSImage("17.circle").symbolConfiguration, NSImage(systemSymbolName: "17.circle", accessibilityDescription: nil)!.symbolConfiguration)
    }
    #endif

    func testValidSymbol() throws {
#if canImport(Macros)
        assertMacroExpansion(
        """
        #NSImage("17.circle")
        """,
        expandedSource:
        """
        NSImage(systemSymbolName: "17.circle", accessibilityDescription: nil)!
        """,
        macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testURLStringLiteralError() throws {
#if canImport(Macros)
        assertMacroExpansion(
        #"""
        #NSImage("\(variable)")
        """#,
        expandedSource:
        #"""
        #NSImage("\(variable)")
        """#,
        diagnostics: [
            DiagnosticSpec(message: "Static string literal is required", line: 1, column: 1)
        ],
        macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testInvalidSymbol() throws {
#if canImport(Macros)
        assertMacroExpansion(
        """
        #NSImage("69.circle")
        """,
        expandedSource:
        """
        #NSImage("69.circle")
        """,
        diagnostics: [
            DiagnosticSpec(message: #"Invalid SF Symbol"#, line: 1, column: 1)
        ],
        macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
