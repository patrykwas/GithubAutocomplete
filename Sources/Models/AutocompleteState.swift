import Foundation

public enum AutocompleteState: Equatable {
    case idle
    case loading
    case loaded([AutocompleteItem])
    case empty
    case error(String)
}
