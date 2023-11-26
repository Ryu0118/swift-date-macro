import Foundation

@freestanding(expression)
public macro date(
    _ dateString: StaticString,
    dateFormat: StaticString
) -> Date = #externalMacro(module: "DateMacroMacros", type: "DateMacro")
