package com.blank.basetemplate

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.blank.feature.navigation.MainNavGraph
import com.blank.core.ui.theme.BaseTemplateTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            BaseTemplateTheme {
                MainNavGraph()
            }
        }
    }
}
