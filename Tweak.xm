#import "libcolorpicker.h"

@interface PHBottomBarButton : UIView
@end

@interface UITabBarButtonLabel : UILabel

@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

static NSMutableDictionary *prefs;
static bool enabled;
static bool useRoman;
static float btnRadius;
static float btnWidth;
static float btnHeight;
static BOOL labelsEnabled;
static NSString *pButtonColor = nil;
//static NSString *oButtonColor = nil;
static NSString *uButtonColor = nil;

static void loadPrefs() {
  prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.eazy-z.npf.plist"];
  enabled = [prefs valueForKey:@"isEnabled"] ? [[prefs valueForKey:@"isEnabled"] boolValue] : YES;
  useRoman = [prefs valueForKey:@"useRoman"] ? [[prefs valueForKey:@"useRoman"] boolValue] : NO;
  btnRadius = [prefs valueForKey:@"btnRadius"] ? [[prefs valueForKey:@"btnRadius"] floatValue] : 17;
  btnWidth = [prefs valueForKey:@"btnWidth"] ? [[prefs valueForKey:@"btnWidth"] floatValue] : 75;
  btnHeight = [prefs valueForKey:@"btnHeight"] ? [[prefs valueForKey:@"btnHeight"] floatValue] : 75;
  labelsEnabled = [prefs objectForKey:@"labelsEnabled"] ? ((NSNumber *)[prefs objectForKey:@"labelsEnabled"]).boolValue : YES;
  pButtonColor = [prefs objectForKey:@"pButtonColor"];
  //oButtonColor = [prefs objectForKey:@"oButtonColor"];
  uButtonColor = [prefs objectForKey:@"uButtonColor"];
}


%hook PHBottomBarButton // This here sets the radius of the call button it self.
-(void)layoutSubviews {
  if (enabled) {
    [self setBounds:CGRectMake(0, 0, btnWidth, btnHeight)];
  }
  %orig;
}

-(void)setBackgroundColor:(id)arg1 {
  arg1 = LCPParseColorString(pButtonColor, @"#00fff2");
  %orig(arg1);
}

%end

%hook UIView // This sets the radius of the dialer buttons. (Had to use UIView as it is the only thing that works.)
-(void)didMoveToWindow {
  if (enabled) {
    CGFloat viewCRadius = [self.layer cornerRadius];
    if(viewCRadius == 36 || viewCRadius == 37.5) {
      [self.layer setBounds:CGRectMake(0, 0, btnWidth, btnHeight)];
      [self.layer setCornerRadius:btnRadius];
    }
  }
  %orig;
}
%end

%hook PHHandsetDialerNumberPadButton

-(void)layoutSubviews {
  [self setColor:LCPParseColorString(uButtonColor, @"#bf00ff")];
}
%end


%hook UITabBarButtonLabel //Hides the tabbar labels.

- (void)layoutSubviews {
    %orig;
    if (labelsEnabled)
        self.hidden = YES;
    }

%end

/*%hook PHHandsetDialerView

-(void)setBackgroundColor:(id)arg1 {
  arg1 = LCPParseColorString(oButtonColor, @"#FFFFF");
  %orig(arg1);
}

%end*/


UIView *buttonView;

%hook TPNumberPadLightStyleButton

-(UIView *)circleView
{
    buttonView = %orig;
    return buttonView;
}

+(id)imageForCharacter:(unsigned)arg1 {
    if (useRoman) {
      UILabel *romanLabel = [[UILabel alloc] initWithFrame:buttonView.frame];
      switch (arg1) {
          case 0:
              romanLabel.text = @"I";
              break;
          case 1:
              romanLabel.text = @"II";
              break;
          case 2:
              romanLabel.text = @"III";
              break;
          case 3:
              romanLabel.text = @"IV";
              break;
          case 4:
              romanLabel.text = @"V";
              break;
          case 5:
              romanLabel.text = @"VI";
              break;
          case 6:
              romanLabel.text = @"VII";
              break;
          case 7:
              romanLabel.text = @"VIII";
              break;
          case 8:
              romanLabel.text = @"IX";
              break;
          case 9:
              romanLabel.text = @"*";
              break;
          case 10:
              romanLabel.text = @"-";
              break;
          case 11:
              romanLabel.text = @"#";
              break;
          default:
              return %orig;
              break;
      }
      romanLabel.font = [UIFont systemFontOfSize:buttonView.frame.size.width / 3];
      romanLabel.textAlignment = NSTextAlignmentCenter;
      [buttonView.superview addSubview:romanLabel];
  	return %orig(-1);
  } else {
    return %orig;
  }
}
%end

%hook TPNumberPadDarkStyleButton

-(UIView *)circleView
{
    buttonView = %orig;
    return buttonView;
}

+(id)imageForCharacter:(unsigned)arg1
{
    UILabel *romanLabel = [[UILabel alloc] initWithFrame:buttonView.frame];
    switch (arg1)
    {
        case 0:
            romanLabel.text = @"I";
            break;
        case 1:
            romanLabel.text = @"II";
            break;
        case 2:
            romanLabel.text = @"III";
            break;
        case 3:
            romanLabel.text = @"IV";
            break;
        case 4:
            romanLabel.text = @"V";
            break;
        case 5:
            romanLabel.text = @"VI";
            break;
        case 6:
            romanLabel.text = @"VII";
            break;
        case 7:
            romanLabel.text = @"VIII";
            break;
        case 8:
            romanLabel.text = @"IX";
            break;
        case 9:
            romanLabel.text = @"*";
            break;
        case 10:
            romanLabel.text = @"-";
            break;
        case 11:
            romanLabel.text = @"#";
            break;
        default:
            return %orig;
            break;
    }
    romanLabel.font = [UIFont systemFontOfSize:buttonView.frame.size.width / 3];
    romanLabel.textAlignment = NSTextAlignmentCenter;
	romanLabel.textColor = [UIColor whiteColor];
    [buttonView.superview addSubview:romanLabel];
	return %orig(-1);
}

%end


%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(
	CFNotificationCenterGetDarwinNotifyCenter(), NULL,
	(CFNotificationCallback)loadPrefs,
	CFSTR("com.eazy-z.npf/prefChanged"), NULL,
	CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}
