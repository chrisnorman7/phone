/// Provides the [label] function, and the [LabelType] typedef.
library label;

/// The type for all label functions.
typedef LabelType = String Function();

/// A function to return a [LabelType] function from the string [text].
LabelType label(String text) => () => text;
