package com.example.ci_project

import android.content.Context
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.facebook.testing.screenshot.Screenshot
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ScreenshotTest {
    @Test
    fun captureMainScreen() {
        val context: Context = InstrumentationRegistry.getInstrumentation().targetContext
        Screenshot.snapActivity(MainActivity::class.java).record()
    }
}
