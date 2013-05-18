@implementation NSString (Empty)

- (BOOL) isEmpty{
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}

@end