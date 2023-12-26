@attached(member, names: arbitrary)
@attached(
    peer,
    names:
    named(MockType),
    named(MockType2)
)
public macro Mock() = #externalMacro(
    module: "SwiftMocksMacros",
    type: "SwiftMocksMacro"
)
