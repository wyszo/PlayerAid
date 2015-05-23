#import "User.h"
#import <KZAsserts.h>
#import <KZPropertyMapper.h>
#import <UIImageView+AFNetworking.h>


@implementation User

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  
  NSDictionary *mapping = @{
                            @"name" : KZProperty(name),
                            @"picture" : KZProperty(pictureURL),
                            @"description" : KZProperty(userDescription),
                            // TODO: followers
                            // TODO: following
                            // TODO: likes
                            // TODO: tutorials
                           };
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
}

- (void)placeAvatarInImageView:(UIImageView *)imageView
{
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(self.pictureURL);
  
  [imageView setImageWithURL:[NSURL URLWithString:self.pictureURL]];
}

@end
