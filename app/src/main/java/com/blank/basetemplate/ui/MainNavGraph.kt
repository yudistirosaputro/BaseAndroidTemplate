package com.blank.basetemplate.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.blank.basetemplate.ui.MainNavigation.SplashNavigation
import com.blank.basetemplate.ui.MainNavigation.HomeNavigation
import com.blank.basetemplate.ui.home.HomeScreen
import com.blank.basetemplate.ui.splash.SplashScreen

@Composable
fun MainNavGraph(
    modifier: Modifier = Modifier,
    navController: NavHostController = rememberNavController(),
    startDestination: MainNavigation = SplashNavigation,
    ) {

    NavHost(
        navController = navController,
        startDestination = startDestination,
        modifier = modifier
    ) {
        composable<SplashNavigation> {
            SplashScreen(modifier) {
                navController.navigate(HomeNavigation)
            }
        }
        composable<HomeNavigation> {
            HomeScreen()
        }

    }
}