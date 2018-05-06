public enum ContentSdkError: Error {
    case newrorkError
    case configError
    case serverError(reason: String)
}
