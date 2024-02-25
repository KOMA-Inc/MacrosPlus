import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public class ImageMacro: SFImageMacro, ExpressionMacro {

    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> ExprSyntax {
        let systemName = try systemName(from: node)
        try validateSFSymbol(named: systemName, in: node)
        return expansion(using: systemName)
    }

    private static func expansion(using systemName: String) -> ExprSyntax {
        "Image(systemName: \"\(raw: systemName)\")"
    }
}
