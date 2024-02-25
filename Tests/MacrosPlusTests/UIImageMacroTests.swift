import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import MacrosPlus

#if canImport(Macros)
import Macros

private let testMacros: [String: Macro.Type] = [
    "UIImage": UIImageMacro.self
]
#endif

#if canImport(UIKit)
import UIKit
#endif


final class UIImageMacroTests: XCTestCase {

    #if canImport(UIKit)
    func testUsage() {
        XCTAssertEqual(#Image("17.circle"), UIImage(systemName: "17.circle")!)
    }
    #endif

    func testValidSymbol() throws {
#if canImport(Macros)
        assertMacroExpansion(
        """
        #UIImage("17.circle")
        """,
        expandedSource:
        """
        UIImage(systemName: "17.circle")!
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
        #UIImage("\(variable)")
        """#,
        expandedSource:
        #"""
        #UIImage("\(variable)")
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
        #UIImage("69.circle")
        """,
        expandedSource:
        """
        #UIImage("69.circle")
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
