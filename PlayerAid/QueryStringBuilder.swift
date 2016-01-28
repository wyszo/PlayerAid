import Foundation

class QueryStringBuilder {
    func queryString(fromDictionary parameters: [String : AnyObject]) -> String {
        var queryVariables: [String] = []

        for (key, value) in parameters {
            let stringValue = value as? String

            if let encodedValue = stringValue?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                queryVariables.append(key + "=" + encodedValue)
            }
        }
        return (queryVariables.isEmpty ? "" : "?" + queryVariables.joinWithSeparator("&"))
    }
}
