package dev.flutter.qr_scanner

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions

class QrScannerActivity : ComponentActivity() {
    private lateinit var barcodeLauncher: ActivityResultLauncher<ScanOptions>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startQRScanner()
    }

    private fun startQRScanner() {
        barcodeLauncher = registerForActivityResult(ScanContract()) { result ->
            if (result.contents != null) {
                setResult(RESULT_OK, intent.putExtra("SCAN_RESULT", result.contents))
            } else {
                setResult(RESULT_CANCELED)
            }
            finish()
        }
        scanBarcode()
    }

    private fun scanBarcode() {
        barcodeLauncher.launch(
            ScanOptions()
                .setPrompt("Scan QR Code")
                .setOrientationLocked(true)
                .setDesiredBarcodeFormats(ScanOptions.ALL_CODE_TYPES)
        )
    }
}
