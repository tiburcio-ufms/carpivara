# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Maps Flutter Plugin
-dontwarn io.flutter.plugins.googlemaps.Convert$BitmapDescriptorFactoryWrapper
-dontwarn io.flutter.plugins.googlemaps.Convert
-dontwarn io.flutter.plugins.googlemaps.GoogleMapController$1
-dontwarn io.flutter.plugins.googlemaps.HeatmapController
-dontwarn io.flutter.plugins.googlemaps.HeatmapOptionsSink
-dontwarn io.flutter.plugins.googlemaps.Messages$FlutterError
-dontwarn io.flutter.plugins.googlemaps.Messages$MapsApi
-dontwarn io.flutter.plugins.googlemaps.Messages$MapsCallbackApi
-dontwarn io.flutter.plugins.googlemaps.Messages$MapsInitializerApi
-dontwarn io.flutter.plugins.googlemaps.Messages$MapsInspectorApi
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformCameraPosition
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformCircle
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformCluster
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformClusterManager
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformGroundOverlay
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformHeatmap
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformLatLng
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformLatLngBounds
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformMapConfiguration
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformMapViewCreationParams
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformMarker
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformPoint$Builder
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformPoint
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformPolygon
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformPolyline
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformRendererType
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformTile
-dontwarn io.flutter.plugins.googlemaps.Messages$PlatformTileOverlay
-dontwarn io.flutter.plugins.googlemaps.Messages$Result
-dontwarn io.flutter.plugins.googlemaps.Messages$VoidResult

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Google Play Core (optional - for deferred components)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

