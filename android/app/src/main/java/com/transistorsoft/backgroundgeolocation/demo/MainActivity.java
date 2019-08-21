package com.transistorsoft.backgroundgeolocation.demo;

import android.os.Bundle;

import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SwitchCompat;

import com.google.android.gms.location.LocationRequest;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.TSConfig;
import com.transistorsoft.locationmanager.adapter.callback.TSCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSConnectivityChangeCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofenceCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSHttpResponseCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationProviderChangeCallback;
import com.transistorsoft.locationmanager.event.ConnectivityChangeEvent;
import com.transistorsoft.locationmanager.event.GeofenceEvent;
import com.transistorsoft.locationmanager.event.LocationProviderChangeEvent;
import com.transistorsoft.locationmanager.http.HttpResponse;
import com.transistorsoft.locationmanager.location.TSCurrentPositionRequest;
import com.transistorsoft.locationmanager.location.TSLocation;
import com.transistorsoft.locationmanager.logger.TSLog;

import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {
    private static String TAG = "BackgroundGeolocationDemo";

    private FloatingActionButton mBtnChangePace;
    private SwitchCompat mBtnEnable;
    private FloatingActionButton mBtnCurrentPosition;
    private TextView mLocationView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize UI items.
        mBtnChangePace = findViewById(R.id.btnChangePace);

        mBtnChangePace.setOnClickListener(createdChangePaceClickListener());

        mBtnEnable = findViewById(R.id.btnEnable);
        mBtnEnable.setOnCheckedChangeListener(createEnableSwitchListener());

        mBtnCurrentPosition = findViewById(R.id.btnCurrentPosition);
        mBtnCurrentPosition.setOnClickListener(createCurrentPositionClickListener());
        mLocationView = findViewById(R.id.content);

        configureBackgroundGeolocation();
    }

    private void configureBackgroundGeolocation() {
        BackgroundGeolocation bgGeo = BackgroundGeolocation.getInstance(getApplicationContext(), getIntent());
        final TSConfig config = TSConfig.getInstance(getApplicationContext());

        // @config Enter your own unique username here (eg: Github username)
        // View your tracking in browser by visiting:  http://tracker.transistorsoft.com/your-username
        String username = "transistor-demo";
        // URL to demo server:
        String url = "http://tracker.transistorsoft.com/locations/" + username;
        // Build HTTP params required by demo server.
        JSONObject params = buildHttpParams();

        // Configure the SDK:
        config.updateWithBuilder()
                // Configure Debugging
                .setDebug(true)
                .setLogLevel(5)
                // Configure Geolocation
                .setDesiredAccuracy(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .setDistanceFilter(50f)
                .setStopTimeout(1L)
                // Configure Application behaviour
                .setForegroundService(true)
                .setStopOnTerminate(false)
                .setStartOnBoot(false)
                // Configure HTTP
                .setUrl(url)
                .setParams(params)
                .setHeader("X-FOO", "FOO")  // <-- Optional HTTP headers
                .setHeader("X-BAR", "BAR")
                .commit();

        // Listen to motionchange event
        bgGeo.onMotionChange(createMotionChangeCallback());

        // Listen to location event
        bgGeo.onLocation(createLocationCallback());

        // Listen to geofence event
        bgGeo.onGeofence(createGeofenceCallback());

        // Listen to connectivitychange event
        bgGeo.onConnectivityChange(createConnectivityChangeCallback());

        // Listen to providerchange event
        bgGeo.onLocationProviderChange(createProviderChangeCallback());

        // Listen to http event
        bgGeo.onHttp(createHttpCallback());

        // Finally, signal #ready to the plugin.
        bgGeo.ready(new TSCallback() {
            @Override public void onSuccess() {
                TSLog.logger.debug("[ready] success");
                mBtnEnable.setChecked(config.getEnabled());
            }
            @Override public void onFailure(String error) {
                TSLog.logger.debug("[ready] FAILURE: " + error);
            }
        });
    }

    /**
     * Compose HTTP params for SDK.  These specific params are used by tracker.transistorsoft.com demo server
     * @return
     */
    private JSONObject buildHttpParams() {
        JSONObject params = new JSONObject();
        JSONObject device = new JSONObject();

        try {
            DeviceInfo deviceInfo = DeviceInfo.getInstance(getApplicationContext());

            device.put("uuid", deviceInfo.getUniqueId());
            device.put("model", deviceInfo.getModel());
            device.put("platform", deviceInfo.getPlatform());
            device.put("manufacturer", deviceInfo.getManufacturer());
            device.put("version", deviceInfo.getVersion());
            device.put("framework", "Native");
            params.put("device", device);
        } catch (JSONException e) {}

        return params;
    }
    private View.OnClickListener createdChangePaceClickListener() {
        return new View.OnClickListener() {
            @Override public void onClick(View view) {
                // Toggle BackgroundGeolocation ON or OFF.
                TSConfig config = TSConfig.getInstance(getApplicationContext());
                BackgroundGeolocation bgGeo = BackgroundGeolocation.getInstance(getApplicationContext());

                boolean isMoving = !config.getIsMoving();
                bgGeo.changePace(isMoving);
                int icon = (isMoving) ? android.R.drawable.ic_media_pause : android.R.drawable.ic_media_play;
                mBtnChangePace.setImageResource(icon);
            }
        };
    }

    private CompoundButton.OnCheckedChangeListener createEnableSwitchListener() {
        return new CompoundButton.OnCheckedChangeListener() {
            @Override public void onCheckedChanged(CompoundButton buttonView, boolean isMoving) {
                BackgroundGeolocation bgGeo = BackgroundGeolocation.getInstance(getApplicationContext());
                mBtnChangePace.setEnabled(isMoving);
                if (isMoving) {
                    bgGeo.start();
                } else {
                    bgGeo.stop();
                }
            }
        };
    }

    private View.OnClickListener createCurrentPositionClickListener() {
        return new View.OnClickListener() {
            @Override public void onClick(View view) {
                // Optional #extras to attach to recorded location.
                JSONObject extras = new JSONObject();
                try {
                    extras.put("jobId", 1234);
                } catch (JSONException e) { }
                // Build position request.
                TSCurrentPositionRequest request = new TSCurrentPositionRequest.Builder(getApplicationContext())
                        .setPersist(true)       // <-- yes, persist to database
                        .setSamples(3)          // <-- fetch 3 location samples and return highest accuracy
                        .setExtras(extras)      // <-- optional #extras
                        .setMaximumAge(5000L)   // <-- if a location <= 5s ago is available, return it.
                        .setDesiredAccuracy(40) // <-- if a location having accuracy <= 40 arrives, return it right away.
                        .build();

                BackgroundGeolocation bgGeo = BackgroundGeolocation.getInstance(getApplicationContext());
                bgGeo.getCurrentPosition(request);
            }
        };
    }

    private TSLocationCallback createMotionChangeCallback() {
        return new TSLocationCallback() {
            @Override public void onLocation(TSLocation location) {
                TSLog.logger.debug("[motionchange] " + location.getJson());
                int icon = (location.getIsMoving()) ? android.R.drawable.ic_media_pause : android.R.drawable.ic_media_play;
                mBtnChangePace.setImageResource(icon);
            }
            @Override public void onError(Integer error) {
                TSLog.logger.debug("[motionchange] FAILURE: " + error);
            }
        };
    }

    private TSLocationCallback createLocationCallback() {
        return new TSLocationCallback() {
            @Override public void onLocation(TSLocation location) {
                TSLog.logger.debug("[location] " + location.toJson());
                try {
                    CharSequence json = location.toJson().toString(2);
                    mLocationView.setText(json);
                } catch (JSONException e) {

                }
            }
            @Override public void onError(Integer error) {
                TSLog.logger.debug("[location] FAILURE: " + error);
            }
        };
    }

    private TSHttpResponseCallback createHttpCallback() {
        return new TSHttpResponseCallback() {
            @Override
            public void onHttpResponse(HttpResponse httpResponse) {
                TSLog.logger.debug("[http] " + httpResponse.status + ": " + httpResponse.responseText);
            }
        };
    }
    private TSGeofenceCallback createGeofenceCallback() {
        return new TSGeofenceCallback() {
            @Override
            public void onGeofence(GeofenceEvent event) {
                TSLog.logger.debug("[geofence] " + event.toJson());
            }
        };
    }

    private TSConnectivityChangeCallback createConnectivityChangeCallback() {
        return new TSConnectivityChangeCallback() {
            @Override
            public void onConnectivityChange(ConnectivityChangeEvent event) {
                TSLog.logger.debug("[connectivitychange] Network connected? " + event.hasConnection());
            }
        };
    }

    private TSLocationProviderChangeCallback createProviderChangeCallback() {
        return new TSLocationProviderChangeCallback() {
            @Override
            public void onLocationProviderChange(LocationProviderChangeEvent event) {
                TSLog.logger.debug("[providerchange] " + event.toJson());
            }
        };
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}