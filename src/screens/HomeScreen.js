import React from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Text, Card, Button, Appbar } from 'react-native-paper';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';

const HomeScreen = ({ navigation }) => {
  const menuItems = [
    {
      title: 'Find Customer',
      subtitle: 'Search customer database',
      icon: 'search',
      color: '#4CAF50',
      screen: 'CustomerSearch'
    },
    {
      title: 'Schedule Meeting',
      subtitle: 'Book appointments',
      icon: 'calendar',
      color: '#2196F3',
      screen: 'MeetingScheduler'
    },
    {
      title: 'Service Report',
      subtitle: 'Create work reports',
      icon: 'document-text',
      color: '#FF9800',
      screen: 'ServiceReport'
    },
    {
      title: 'Digital Signature',
      subtitle: 'Capture signatures',
      icon: 'create',
      color: '#9C27B0',
      screen: 'Signature'
    }
  ];

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header Card */}
        <Card style={styles.headerCard}>
          <LinearGradient
            colors={['#4CAF50', '#2196F3']}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
            style={styles.headerGradient}
          >
            <Text style={styles.welcomeText}>Welcome to</Text>
            <Text style={styles.titleText}>TAD Service</Text>
            <Text style={styles.subtitleText}>Professional Field Service Management</Text>
          </LinearGradient>
        </Card>

        {/* Menu Items */}
        <View style={styles.menuGrid}>
          {menuItems.map((item, index) => (
            <Card key={index} style={styles.menuCard}>
              <Button
                mode="contained"
                onPress={() => navigation.navigate(item.screen)}
                style={[styles.menuButton, { backgroundColor: item.color }]}
                contentStyle={styles.menuButtonContent}
                labelStyle={styles.menuButtonLabel}
              >
                <View style={styles.menuItemContent}>
                  <Ionicons name={item.icon} size={32} color="#ffffff" />
                  <Text style={styles.menuItemTitle}>{item.title}</Text>
                  <Text style={styles.menuItemSubtitle}>{item.subtitle}</Text>
                </View>
              </Button>
            </Card>
          ))}
        </View>

        {/* Stats Card */}
        <Card style={styles.statsCard}>
          <Card.Content>
            <Text style={styles.statsTitle}>Today's Summary</Text>
            <View style={styles.statsRow}>
              <View style={styles.statItem}>
                <Text style={styles.statNumber}>12</Text>
                <Text style={styles.statLabel}>Appointments</Text>
              </View>
              <View style={styles.statItem}>
                <Text style={styles.statNumber}>8</Text>
                <Text style={styles.statLabel}>Completed</Text>
              </View>
              <View style={styles.statItem}>
                <Text style={styles.statNumber}>4</Text>
                <Text style={styles.statLabel}>Pending</Text>
              </View>
            </View>
          </Card.Content>
        </Card>
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#121212',
  },
  scrollView: {
    flex: 1,
    paddingHorizontal: 16,
  },
  headerCard: {
    marginVertical: 16,
    borderRadius: 16,
    overflow: 'hidden',
    elevation: 8,
  },
  headerGradient: {
    padding: 32,
    alignItems: 'center',
  },
  welcomeText: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 16,
    color: '#ffffff',
    opacity: 0.9,
  },
  titleText: {
    fontFamily: 'SpaceGrotesk-Bold',
    fontSize: 32,
    color: '#ffffff',
    marginVertical: 8,
  },
  subtitleText: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#ffffff',
    opacity: 0.8,
    textAlign: 'center',
  },
  menuGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginBottom: 16,
  },
  menuCard: {
    width: '48%',
    marginBottom: 16,
    borderRadius: 12,
    overflow: 'hidden',
  },
  menuButton: {
    borderRadius: 12,
    elevation: 4,
  },
  menuButtonContent: {
    height: 120,
    justifyContent: 'center',
  },
  menuButtonLabel: {
    fontSize: 0, // Hide default label
  },
  menuItemContent: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  menuItemTitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 14,
    color: '#ffffff',
    marginTop: 8,
    textAlign: 'center',
  },
  menuItemSubtitle: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 11,
    color: '#ffffff',
    opacity: 0.8,
    marginTop: 4,
    textAlign: 'center',
  },
  statsCard: {
    marginBottom: 32,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
  },
  statsTitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 18,
    color: '#ffffff',
    marginBottom: 16,
    textAlign: 'center',
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statNumber: {
    fontFamily: 'SpaceGrotesk-Bold',
    fontSize: 24,
    color: '#4CAF50',
  },
  statLabel: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 12,
    color: '#ffffff',
    opacity: 0.7,
    marginTop: 4,
  },
});

export default HomeScreen;
