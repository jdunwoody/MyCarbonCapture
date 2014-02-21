#import "UIImageToDataTransformer.h"


@implementation UIImageToDataTransformer


+(BOOL)allowsReverseTransformation {
	return YES;
}

+(Class)transformedValueClass {
	return [NSData class];
}

-(id)transformedValue:(id)value {
	return UIImagePNGRepresentation(value);
}

-(UIImage*)reverseTransformedValue:(id)value {
	return [[UIImage alloc] initWithData:value];
}

@end
