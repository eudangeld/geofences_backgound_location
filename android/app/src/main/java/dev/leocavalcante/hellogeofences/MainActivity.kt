package dev.leocavalcante.hellogeofences

import android.Manifest
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices
import org.json.JSONObject

class MainActivity : AppCompatActivity() {
    private lateinit var queue: RequestQueue
    private lateinit var geofencingClient: GeofencingClient

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(this, GeofenceBroadcastReceiver::class.java)
        PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        queue = Volley.newRequestQueue(this)
        startGeofencing()
    }

    private fun startGeofencing() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            geofencingClient = LocationServices.getGeofencingClient(this)
            geofencingClient.addGeofences(getGeofencingRequest(), geofencePendingIntent).run {
                addOnSuccessListener {
                    sendNotification("Geofences added")
                }

                addOnFailureListener {
                    sendNotification("Geofences error")
                }
            }
        } else {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 1);
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        when (requestCode) {
            1 -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    startGeofencing()
                }
            }
        }
    }

    private fun getGeofencingRequest(): GeofencingRequest {
        val home = Geofence.Builder()
            .setRequestId("home")
            .setCircularRegion(
                -23.5814053,
                -46.7630725,
                50F
            )
            .setExpirationDuration(Geofence.NEVER_EXPIRE)
            .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT)
            .build()

        val work = Geofence.Builder()
            .setRequestId("work")
            .setCircularRegion(
                -23.5843221,
                -46.7538992,
                50F
            )
            .setExpirationDuration(Geofence.NEVER_EXPIRE)
            .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT)
            .build()

        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            addGeofences(listOf(home, work))
        }.build()
    }

    private fun sendNotification(message: String) {
        val url = "https://hooks.slack.com/services/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"
        val json = JSONObject(
            mapOf(
                "text" to message
            )
        )

        val request =
            JsonObjectRequest(Request.Method.POST, url, json, Response.Listener { }, Response.ErrorListener { })

        queue.add(request)
    }
}
