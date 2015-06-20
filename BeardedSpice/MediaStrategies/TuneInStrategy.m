//
//  TuneInStrategy.m
//  BeardedSpice
//
//  Created by Michael Alden on 6/16/15.
//  Copyright (c) 2015 Tyler Rhodes / Jose Falcon. All rights reserved.
//

#import "TuneInStrategy.h"

@implementation TuneInStrategy

-(id) init
{
    self = [super init];
    if (self) {
        predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] '*tunein.com*'"];
    }
    return self;
}

-(BOOL) accepts:(TabAdapter *)tab
{
    return [predicate evaluateWithObject:[tab URL]];
}

- (BOOL)isPlaying:(TabAdapter *)tab
{
    NSString *playerState = [tab executeJavascript:@"$('#tuner').attr('class')"];
    return [playerState isEqualToString:@"playing"];
}

-(NSString *) toggle
{
    return @"document.querySelector('.playbutton-cont').click();";
}

-(NSString *) previous
{
    return @"";
}

-(NSString *) next
{
    return @"";
}

-(NSString *) pause
{
    return @"if($('#tuner').attr('class') == 'playing'){document.querySelector('.playbutton-cont').click();}";
}

-(NSString *) favorite
{
    return @"$('.icon.follow').click()";
}

-(NSString *) displayName
{
    return @"TuneIn";
}

-(Track *) trackInfo:(TabAdapter *)tab
{
    NSDictionary *metadata = [tab executeJavascript:@"TuneIn.app.nowPlaying.broadcast"];
    NSString *albumart_url = [tab executeJavascript:@"$('.artwork.col._navigateNowPlaying').children('.image').children('.logo.loaded').attr('src');"];
    Track *track = [[Track alloc] init];
    track.track = [metadata valueForKey:@"DisplaySubtitle"];
    track.album = [metadata valueForKeyPath:@"EchoData.title"];
    track.artist = [metadata valueForKey:@"Location"];
    track.image = [self imageByUrlString:albumart_url];
    track.favorited = [metadata valueForKey:@"IsFollowing"];
    
    return track;
}

@end
