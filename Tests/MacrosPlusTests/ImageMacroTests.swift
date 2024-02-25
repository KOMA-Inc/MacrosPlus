import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import MacrosPlus

#if canImport(Macros)
import Macros

private let testMacros: [String: Macro.Type] = [
    "Image": ImageMacro.self
]
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif


final class ImageMacroTests: XCTestCase {

    #if canImport(SwiftUI)
    func testUsage() {
        XCTAssertEqual(#Image("17.circle"), Image(systemName: "17.circle"))
    }
    #endif

    func testValidSymbol() throws {
#if canImport(Macros)
        assertMacroExpansion(
        """
        #Image("17.circle")
        """,
        expandedSource:
        """
        Image(systemName: "17.circle")
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
        #Image("\(variable)")
        """#,
        expandedSource:
        #"""
        #Image("\(variable)")
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
        #Image("69.circle")
        """,
        expandedSource:
        """
        #Image("69.circle")
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
