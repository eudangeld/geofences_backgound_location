#import "GeofencesBackgoundLocationPlugin.h"
#import <geofences_backgound_location/geofences_backgound_location-Swift.h>

@implementation GeofencesBackgoundLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGeofencesBackgoundLocationPlugin registerWithRegistrar:registrar];
}
@end
