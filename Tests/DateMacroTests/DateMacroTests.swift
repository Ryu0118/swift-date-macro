import SwiftSyntaxMacros
import XCTest
import MacroTesting
import DateMacroMacros

final class DateMacroTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(macros: ["date": DateMacro.self]) {
            super.invokeTest()
        }
    }

    func testDiagnostic() {
        assertMacro {
            """
            let date = #date("202311-11", dateFormat: "yyyy-MM-dd")
            """
        } diagnostics: {
            """
            let date = #date("202311-11", dateFormat: "yyyy-MM-dd")
                       ┬───────────────────────────────────────────
                       ╰─ 🛑 malformed date or dateFormat: 202311-11, yyyy-MM-dd
            """
        }
    }

    func testExpansion() {
        assertMacro {
            """
            let date = #date("2023-11-11", dateFormat: "yyyy-MM-dd")
            """
        } expansion: {
            """
            let date = { () -> Date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                return formatter.date(from: "2023-11-11")!
            }()
            """
        }
    }
}
