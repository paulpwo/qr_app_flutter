package dev.flutter.qr_scanner

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions

class NativeMobileQr : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var binaryMessenger: BinaryMessenger
    private var activityBinding: ActivityPluginBinding? = null
    private var scannerImplementation: QrScannerImplementation? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("NativeMobileQr", "Plugin attaching to engine")
        binaryMessenger = binding.binaryMessenger
        scannerImplementation = QrScannerImplementation()
        NativeHostQr.setUp(binaryMessenger, scannerImplementation)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("NativeMobileQr", "Plugin detaching from engine")
        scannerImplementation = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("NativeMobileQr", "Plugin attaching to activity")
        activityBinding = binding
        scannerImplementation?.initializeWithActivity(binding.activity)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        Log.d("NativeMobileQr", "Plugin detaching from activity")
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        scannerImplementation?.cleanup()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        scannerImplementation?.handleActivityResult(requestCode, resultCode, data)
        return true
    }
}

class QrScannerImplementation : NativeHostQr {
    private var activity: Activity? = null
    private var pendingResult: ((Result<String>) -> Unit)? = null

    fun initializeWithActivity(activity: Activity) {
        this.activity = activity
    }

    fun cleanup() {
        activity = null
        pendingResult = null
    }

    override fun getNativeUiResult(callback: (Result<String>) -> Unit) {
        try {
            val currentActivity = activity
            if (currentActivity == null) {
                callback(Result.failure(FlutterError("NO_ACTIVITY", "Activity is not available", null)))
                return
            }

            pendingResult = callback
            val intent = Intent(currentActivity, QrScannerActivity::class.java)
            currentActivity.startActivityForResult(intent, QR_SCAN_REQUEST_CODE)

        } catch (e: Exception) {
            callback(Result.failure(FlutterError("SCAN_ERROR", e.message, null)))
        }
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == QR_SCAN_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val scanResult = data.getStringExtra("SCAN_RESULT")
                pendingResult?.invoke(Result.success(scanResult ?: ""))
            } else {
                pendingResult?.invoke(Result.failure(FlutterError("SCAN_CANCELLED", "Scan was cancelled", null)))
            }
            pendingResult = null
        }
    }

    companion object {
        private const val QR_SCAN_REQUEST_CODE = 100
    }
}
