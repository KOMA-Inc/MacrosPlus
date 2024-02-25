import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public class SFImageMacro {

    enum DiagnosticError: String, DiagnosticMessage {

        case requiresStaticStringLiteral
        case invalidSFSymbol
        case unsupportedPlatform

        var diagnosticID: MessageID {
            MessageID(domain: "MacrosPlus", id: rawValue)
        }

        var severity: DiagnosticSeverity {
            .error
        }

        var message: String {
            switch self {
            case .requiresStaticStringLiteral:
                "Static string literal is required"
            case .invalidSFSymbol:
                "Invalid SF Symbol"
            case .unsupportedPlatform:
                "Unsupported platform"
            }
        }
    }

    static func systemName(from node: some FreestandingMacroExpansionSyntax) throws -> String {
        guard
            let argument = node.argumentList.first?.expression,
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            case .stringSegment(let literalSegment)? = segments.first
        else {
            let diagnostic = Diagnostic(node: node, message: DiagnosticError.requiresStaticStringLiteral)

            throw DiagnosticsError(diagnostics: [diagnostic])
        }

        return literalSegment.content.text
    }

    static func validateSFSymbol(
        named name: String,
        in node: some FreestandingMacroExpansionSyntax
    ) throws {

        #if canImport(UIKit)
        if UIImage(systemName: name) != nil { return }
        #elseif canImport(AppKit)
        if NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil {
            return
        }

        #else
        let diagnostic = Diagnostic(node: node, message: DiagnosticError.unsupportedPlatform)

        throw DiagnosticsError(diagnostics: [diagnostic])
        #endif

        let diagnostic = Diagnostic(node: node, message: DiagnosticError.invalidSFSymbol)

        throw DiagnosticsError(diagnostics: [diagnostic])
    }
}
