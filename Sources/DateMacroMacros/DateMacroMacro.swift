import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct DateMacro: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext>(
        of node: Node,
        in context: Context
    ) throws -> ExprSyntax {
        guard let firstArgument = node.argumentList.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
              let secondArgument = node.argumentList.last?.expression.as(StringLiteralExprSyntax.self)?.segments,
              case let .stringSegment(dateString) = firstArgument.first,
              case let .stringSegment(dateFormat) = secondArgument.first
        else {
            throw DateMacroError.message("compiler bug: the macro does not have any arguments")
        }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.content.text
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let _ = formatter.date(from: dateString.content.text) else {
            throw DateMacroError.message("malformed date or dateFormat: \(dateString.content.text), \(dateFormat.content.text)")
        }

        return """
        { () -> Date in
            let formatter = DateFormatter()
            formatter.dateFormat = "\(raw: dateFormat.content.text)"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.date(from: "\(raw: dateString.content.text)")!
        }()
        """
    }
}

enum DateMacroError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}

@main
struct DateMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DateMacro.self,
    ]
}
