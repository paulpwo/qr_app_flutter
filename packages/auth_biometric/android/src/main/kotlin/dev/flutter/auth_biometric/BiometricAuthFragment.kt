package dev.flutter.auth_biometric

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.biometric.BiometricPrompt
import androidx.biometric.BiometricPrompt.PromptInfo
import java.util.concurrent.Executor

class BiometricAuthFragment : Fragment() {
    var authCallback: ((Result<Boolean>) -> Unit)? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        retainInstance = true
    }

    override fun onStart() {
        super.onStart()
        val activity = activity as? FragmentActivity
        if (activity == null) {
            authCallback?.invoke(Result.failure(Exception("No FragmentActivity attached")))
            removeSelf()
            return
        }
        val executor: Executor = activity.mainExecutor
        val biometricPrompt = BiometricPrompt(activity, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    Log.d("BiometricAuthFragment", "Authentication succeeded")
                    authCallback?.invoke(Result.success(true))
                    removeSelf()
                }
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    Log.d("BiometricAuthFragment", "Authentication error: $errString")
                    authCallback?.invoke(Result.failure(Exception("Authentication error: $errString")))
                    removeSelf()
                }
                override fun onAuthenticationFailed() {
                    Log.d("BiometricAuthFragment", "Authentication failed")
                    authCallback?.invoke(Result.failure(Exception("Authentication failed")))
                    removeSelf()
                }
            }
        )
        val promptInfo = PromptInfo.Builder()
            .setTitle("Biometric Authentication")
            .setSubtitle("Confirm your identity")
            .setNegativeButtonText("Cancel")
            .build()
        biometricPrompt.authenticate(promptInfo)
    }

    private fun removeSelf() {
        activity?.supportFragmentManager?.beginTransaction()?.remove(this)?.commitAllowingStateLoss()
    }

    companion object {
        fun show(activity: FragmentActivity, callback: (Result<Boolean>) -> Unit) {
            val fragment = BiometricAuthFragment().apply {
                authCallback = callback
            }
            activity.supportFragmentManager.beginTransaction()
                .add(fragment, "BiometricAuthFragment")
                .commitAllowingStateLoss()
        }
    }
}
