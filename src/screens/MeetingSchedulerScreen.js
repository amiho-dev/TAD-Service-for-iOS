import React, { useState } from 'react';
import { View, StyleSheet, ScrollView, Alert } from 'react-native';
import { Text, Card, Button, TextInput, Chip, Portal, Modal } from 'react-native-paper';
import { Calendar } from 'react-native-calendars';
import { Ionicons } from '@expo/vector-icons';

const MeetingSchedulerScreen = () => {
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedTime, setSelectedTime] = useState('');
  const [meetingType, setMeetingType] = useState('shop');
  const [customerName, setCustomerName] = useState('');
  const [description, setDescription] = useState('');
  const [showCalendar, setShowCalendar] = useState(false);

  const timeSlots = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00'
  ];

  const handleScheduleMeeting = () => {
    if (!selectedDate || !selectedTime || !customerName) {
      Alert.alert('Missing Information', 'Please fill in all required fields.');
      return;
    }

    Alert.alert(
      'Meeting Scheduled!',
      `Meeting with ${customerName} scheduled for ${selectedDate} at ${selectedTime}`,
      [{ text: 'OK', onPress: () => resetForm() }]
    );
  };

  const resetForm = () => {
    setSelectedDate('');
    setSelectedTime('');
    setCustomerName('');
    setDescription('');
    setMeetingType('shop');
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Customer Information */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Customer Information</Text>
            <TextInput
              label="Customer Name *"
              value={customerName}
              onChangeText={setCustomerName}
              style={styles.input}
              mode="outlined"
              theme={{
                colors: {
                  primary: '#4CAF50',
                  outline: '#666666',
                  onSurfaceVariant: '#cccccc',
                }
              }}
            />
          </Card.Content>
        </Card>

        {/* Meeting Type */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Meeting Location</Text>
            <View style={styles.chipContainer}>
              <Chip
                selected={meetingType === 'shop'}
                onPress={() => setMeetingType('shop')}
                style={[styles.chip, meetingType === 'shop' && styles.selectedChip]}
                textStyle={styles.chipText}
                icon="storefront"
              >
                At Shop
              </Chip>
              <Chip
                selected={meetingType === 'customer'}
                onPress={() => setMeetingType('customer')}
                style={[styles.chip, meetingType === 'customer' && styles.selectedChip]}
                textStyle={styles.chipText}
                icon="map-marker"
              >
                Customer Location
              </Chip>
            </View>
          </Card.Content>
        </Card>

        {/* Date Selection */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Select Date</Text>
            <Button
              mode="outlined"
              onPress={() => setShowCalendar(true)}
              style={styles.dateButton}
              labelStyle={styles.buttonLabel}
              icon="calendar"
            >
              {selectedDate || 'Choose Date'}
            </Button>
          </Card.Content>
        </Card>

        {/* Time Selection */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Select Time</Text>
            <View style={styles.timeGrid}>
              {timeSlots.map((time) => (
                <Chip
                  key={time}
                  selected={selectedTime === time}
                  onPress={() => setSelectedTime(time)}
                  style={[
                    styles.timeChip,
                    selectedTime === time && styles.selectedTimeChip
                  ]}
                  textStyle={styles.timeChipText}
                >
                  {time}
                </Chip>
              ))}
            </View>
          </Card.Content>
        </Card>

        {/* Description */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Description (Optional)</Text>
            <TextInput
              label="Meeting purpose or notes"
              value={description}
              onChangeText={setDescription}
              style={styles.input}
              mode="outlined"
              multiline
              numberOfLines={3}
              theme={{
                colors: {
                  primary: '#4CAF50',
                  outline: '#666666',
                  onSurfaceVariant: '#cccccc',
                }
              }}
            />
          </Card.Content>
        </Card>

        {/* Schedule Button */}
        <Button
          mode="contained"
          onPress={handleScheduleMeeting}
          style={styles.scheduleButton}
          labelStyle={styles.scheduleButtonLabel}
          icon="calendar-check"
        >
          Schedule Meeting
        </Button>
      </ScrollView>

      {/* Calendar Modal */}
      <Portal>
        <Modal
          visible={showCalendar}
          onDismiss={() => setShowCalendar(false)}
          contentContainerStyle={styles.modalContainer}
        >
          <Calendar
            onDayPress={(day) => {
              setSelectedDate(day.dateString);
              setShowCalendar(false);
            }}
            minDate={new Date().toISOString().split('T')[0]}
            theme={{
              backgroundColor: '#1e1e1e',
              calendarBackground: '#1e1e1e',
              textSectionTitleColor: '#ffffff',
              selectedDayBackgroundColor: '#4CAF50',
              selectedDayTextColor: '#ffffff',
              todayTextColor: '#4CAF50',
              dayTextColor: '#ffffff',
              textDisabledColor: '#666666',
              dotColor: '#4CAF50',
              selectedDotColor: '#ffffff',
              arrowColor: '#4CAF50',
              monthTextColor: '#ffffff',
              indicatorColor: '#4CAF50',
            }}
          />
        </Modal>
      </Portal>
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
  card: {
    marginVertical: 8,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
    elevation: 4,
  },
  sectionTitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 16,
    color: '#ffffff',
    marginBottom: 16,
  },
  input: {
    backgroundColor: '#2a2a2a',
    fontFamily: 'SpaceGrotesk-Regular',
  },
  chipContainer: {
    flexDirection: 'row',
    gap: 12,
  },
  chip: {
    backgroundColor: '#2a2a2a',
  },
  selectedChip: {
    backgroundColor: '#4CAF5020',
    borderColor: '#4CAF50',
    borderWidth: 1,
  },
  chipText: {
    fontFamily: 'SpaceGrotesk-Medium',
    color: '#ffffff',
  },
  dateButton: {
    borderColor: '#666666',
    borderRadius: 8,
  },
  buttonLabel: {
    fontFamily: 'SpaceGrotesk-Medium',
    color: '#ffffff',
  },
  timeGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  timeChip: {
    backgroundColor: '#2a2a2a',
    marginBottom: 8,
  },
  selectedTimeChip: {
    backgroundColor: '#4CAF50',
  },
  timeChipText: {
    fontFamily: 'SpaceGrotesk-Medium',
    fontSize: 12,
    color: '#ffffff',
  },
  scheduleButton: {
    backgroundColor: '#4CAF50',
    marginVertical: 24,
    borderRadius: 12,
    paddingVertical: 8,
  },
  scheduleButtonLabel: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 16,
    color: '#ffffff',
  },
  modalContainer: {
    backgroundColor: '#1e1e1e',
    margin: 20,
    borderRadius: 12,
    padding: 20,
  },
});

export default MeetingSchedulerScreen;
