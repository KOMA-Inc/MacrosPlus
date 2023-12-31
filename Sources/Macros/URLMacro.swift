import SwiftSyntaxMacros
import SwiftSyntax
import Foundation

public struct URLMacro: ExpressionMacro {

    enum Error: Swift.Error, CustomStringConvertible {
        case requiresStaticStringLiteral
        case malformedURL(urlString: String)

        var description: String {
            switch self {
            case .requiresStaticStringLiteral:
                "#URL requires a static string literal"
            case .malformedURL(let urlString):
                "The input URL is malformed: \(urlString)"
            }
        }
    }

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.argumentList.first?.expression,
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw Error.requiresStaticStringLiteral
        }

        guard let _ = URL(string: literalSegment.content.text) else {
            throw Error.malformedURL(urlString: "\(argument)")
        }

        return "URL(string: \(argument))!"
    }
}
