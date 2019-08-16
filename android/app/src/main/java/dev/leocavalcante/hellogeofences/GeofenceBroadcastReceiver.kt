package dev.leocavalcante.hellogeofences

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent
import org.json.JSONObject

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    private lateinit var queue: RequestQueue

    override fun onReceive(context: Context?, intent: Intent?) {
        queue = Volley.newRequestQueue(context)

        val geofencingEvent = GeofencingEvent.fromIntent(intent)

        if (geofencingEvent.hasError()) {
            sendNotification("Has error");
            return
        }

        val geofenceTransition = geofencingEvent.geofenceTransition
        val geofenceRequestId = geofencingEvent.triggeringGeofences[0].requestId

        if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER) {
            sendNotification("ENTER $geofenceRequestId")
        }

        if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_EXIT) {
            sendNotification("EXIT $geofenceRequestId")
        }
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