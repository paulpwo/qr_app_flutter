package dev.flutter.auth_biometric

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.PluginRegistry

class NativeMobileAuthBiometric : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener  {
    private lateinit var binaryMessenger: BinaryMessenger
    private var activityBinding: ActivityPluginBinding? = null
    private var biometricImplementation: BiometricAuthImplementation? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = binding.binaryMessenger
        biometricImplementation = BiometricAuthImplementation()
        NativeMobileAuthBiometricHost.setUp(binaryMessenger, biometricImplementation)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        NativeMobileAuthBiometricHost.setUp(binaryMessenger, null)
        biometricImplementation = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        biometricImplementation?.initializeWithActivity(binding.activity)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        Log.d("NativeMobileAuthBiometric", "Plugin detaching from activity")

        activityBinding?.removeActivityResultListener(this)
        biometricImplementation?.cleanup()
        activityBinding = null
        
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

     override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        biometricImplementation?.handleActivityResult(requestCode, resultCode, data)
        return true
    }
}

class BiometricAuthImplementation : NativeMobileAuthBiometricHost {
    private var activity: Activity? = null
    private var pendingResult: ((Result<Boolean>) -> Unit)? = null

    fun initializeWithActivity(activity: Activity) {
        this.activity = activity
    }

    fun cleanup() {
        activity = null
        pendingResult = null
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        Log.d("NativeMobileAuthBiometric", "Handling activity result $requestCode, $resultCode")
        if (requestCode == BIOMETRIC_REQUEST_CODE) {
            Log.d("NativeMobileAuthBiometric", "Received biometric activity result")
            // Send only one response based on the result
            val result = when (resultCode) {
                Activity.RESULT_OK -> {
                    Log.d("NativeMobileAuthBiometric", "Biometric authentication succeeded")
                    Result.success(true)
                }
                else -> {
                    Log.d("NativeMobileAuthBiometric", "Biometric authentication failed")
                    Result.success(false)
                }
            }
            pendingResult?.invoke(result)
            pendingResult = null
        }
    }

    override fun isAvailable(callback: (Result<Boolean>) -> Unit) {
        Log.d("NativeMobileAuthBiometric", "Checking biometric availability")
        try {
            val currentActivity = activity
            if (currentActivity == null) {
                callback(Result.failure(FlutterError("NO_ACTIVITY", "Activity is not available", null)))
                return
            }

            pendingResult = callback
            //Open the biometric activity witch intent for pass BiometricPrompt real Context activity
            val intent = Intent(currentActivity, BiometricAuthActivity::class.java)
            currentActivity.startActivityForResult(intent, BIOMETRIC_REQUEST_CODE)

        } catch (e: Exception) {
            callback(Result.failure(FlutterError("SCAN_ERROR", e.message, null)))
        }
    }

        companion object {
        private const val BIOMETRIC_REQUEST_CODE = 101
    }
}