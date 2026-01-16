import SwiftParser
import SwiftSyntax

struct ParseOutput {
    let path: String
    let syntax: SourceFileSyntax
    let locationConverter: SourceLocationConverter
}
