import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import HomeScreen from '../screens/HomeScreen';
import CustomerSearchScreen from '../screens/CustomerSearchScreen';
import MeetingSchedulerScreen from '../screens/MeetingSchedulerScreen';
import ServiceReportScreen from '../screens/ServiceReportScreen';
import SignatureScreen from '../screens/SignatureScreen';

const Stack = createStackNavigator();

const Navigation = () => {
  return (
    <NavigationContainer
      theme={{
        dark: true,
        colors: {
          primary: '#4CAF50',
          background: '#121212',
          card: '#1e1e1e',
          text: '#ffffff',
          border: '#333333',
          notification: '#4CAF50',
        },
      }}
    >
      <Stack.Navigator
        initialRouteName="Home"
        screenOptions={{
          headerStyle: {
            backgroundColor: '#1e1e1e',
          },
          headerTintColor: '#ffffff',
          headerTitleStyle: {
            fontFamily: 'SpaceGrotesk-SemiBold',
            fontSize: 18,
          },
        }}
      >
        <Stack.Screen 
          name="Home" 
          component={HomeScreen} 
          options={{ title: 'TAD Service' }}
        />
        <Stack.Screen 
          name="CustomerSearch" 
          component={CustomerSearchScreen} 
          options={{ title: 'Find Customer' }}
        />
        <Stack.Screen 
          name="MeetingScheduler" 
          component={MeetingSchedulerScreen} 
          options={{ title: 'Schedule Meeting' }}
        />
        <Stack.Screen 
          name="ServiceReport" 
          component={ServiceReportScreen} 
          options={{ title: 'Service Report' }}
        />
        <Stack.Screen 
          name="Signature" 
          component={SignatureScreen} 
          options={{ title: 'Digital Signature' }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default Navigation;
