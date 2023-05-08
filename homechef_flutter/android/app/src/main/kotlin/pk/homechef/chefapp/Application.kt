package pk.homechef.chefapp

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
        //com.google.flutter.plugins.audiofileplayer.AudiofileplayerPlugin.registerWith(registry?.registrarFor("com.google.flutter.plugins.audiofileplayer.AudiofileplayerPlugin"));
        //io.flutter.plugins.pathprovider.PathProviderPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
        io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }
}