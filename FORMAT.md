# Formatting guidelines of CGIKit 6

I have seed *lots* of ranting, venting and nasty workings around Github on how
source code should be formatted. Here is the convention I am going to use, and
am going to "force" all controbutors into using.

## Code style

Generally, all functions and methods should be indented in Allman (ISO) style.
Tab width should be 4 and you should indent using spaces (Both came as default
settings of Xcode 4, the code editor I used. I think you can make your editor do
so too.)

Operators should have a space before and after it, generally. Exceptions are dot
operator sthat deliminates a structure and its field (or an object and its
property) and `->` operator deliminates structure pointer (or object) and its
field.

Brackets denoting function parameters should follow the function name 
immediately. (Semi)colons should be used with suffix space but no prefix space,
and brackets should not have inner spaces, just as the same way they are used in
typing literature. Colons and brackets in Objective-C method signatures and
calls have no space around unless a `+` or `-` before the bracket, as Apple used
in system headers and documentations.

Asterisks `*` denoting pointers should have spaces between them and underlying
data type, but no space between them and the variable name.

For Objective-C constructs, `@` should be immediately before the construct
without any trailing spaces.

## Object interfaces

For C++ classes and C structure/unions, as well as Objective-C ivar lists, the
rule for functions (methods) apply.

For Objective-C classes, do not indent properties and methods. (This should be
default on Xcode too.) There should be at one empty line between method block
and `@interface`/ivar list/`@end`. The same applies for `@implementation` too.

Implementations of methods and functions should be seperated with at least one
blank line.

When listing C function parameter types in prototypes and function pointers, do
not include parameter names unless the prototype is being documented.

## Break lines in the middle of a statement

Long parameter lists and method calls should be broken into multiple lines, one
lineeach argument.

For functions all arguments should begin on the row after the opening bracket,
and the closing bracket should be immediately after the last argument.

For method calls all colons should be lined up. (This can be achieved
automatically by Xcode) The first part of the method name should be on the first
line of the call, in the sam line with the object.

However, whenever a block parameter is involved, do not break the line.

## Blocks

Due to the semantics of blocks, unlike all other constructs involving curly
braces, the opening braces is on the same line as the argument list, or using
the K&R style. Also, blocks will prevent the function (method) call from being
broken into multiple lines.

## Comments

Always put a space after the single-line comment symbol, `//`.

Lines of comments should not cross the 80-character column. (Xcode can tell you
that by showing a ruler on the column. This is not a default though but it is
trivial to turn it on from Xcode Preferences.) However for code embedded this
rule does not apply.

The 80-character rule and code-in-comment exemption also applies for other
plain-text documentations, ike this Markdown file.

When using `/* */` comments on a single line, put spaces before and after the
comment, when on multiple lines, letthe symbol take a single line. (For inline
documentation to work, do not break the `/**` construct.)

When an inline documentation block is used on a function prototype or a method,
the prototype is placed on the line immediately after the comment, and a blank
line is always placed before. Do not use the comment-after-argument style as it
is not recognized by either Xcode or `appledoc`.
