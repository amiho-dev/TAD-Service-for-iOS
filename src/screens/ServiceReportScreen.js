import React, { useState } from 'react';
import { View, StyleSheet, ScrollView, Alert } from 'react-native';
import { Text, Card, Button, TextInput, Chip } from 'react-native-paper';
import { Ionicons } from '@expo/vector-icons';

const ServiceReportScreen = ({ navigation }) => {
  const [customerName, setCustomerName] = useState('');
  const [serviceType, setServiceType] = useState('');
  const [description, setDescription] = useState('');
  const [timeSpent, setTimeSpent] = useState('');
  const [partsUsed, setPartsUsed] = useState('');
  const [recommendations, setRecommendations] = useState('');
  const [reportStatus, setReportStatus] = useState('in-progress');

  const serviceTypes = [
    'Repair', 'Maintenance', 'Installation', 'Inspection', 'Consultation'
  ];

  const statusOptions = [
    { value: 'in-progress', label: 'In Progress', color: '#FF9800' },
    { value: 'completed', label: 'Completed', color: '#4CAF50' },
    { value: 'pending-parts', label: 'Pending Parts', color: '#F44336' },
    { value: 'follow-up', label: 'Follow-up Required', color: '#2196F3' }
  ];

  const handleSaveReport = () => {
    if (!customerName || !serviceType || !description) {
      Alert.alert('Missing Information', 'Please fill in all required fields.');
      return;
    }

    Alert.alert(
      'Report Saved!',
      'Service report has been saved successfully.',
      [
        { text: 'New Report', onPress: () => resetForm() },
        { text: 'Add Signature', onPress: () => navigation.navigate('Signature') },
        { text: 'OK' }
      ]
    );
  };

  const resetForm = () => {
    setCustomerName('');
    setServiceType('');
    setDescription('');
    setTimeSpent('');
    setPartsUsed('');
    setRecommendations('');
    setReportStatus('in-progress');
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

        {/* Service Type */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Service Type *</Text>
            <View style={styles.chipContainer}>
              {serviceTypes.map((type) => (
                <Chip
                  key={type}
                  selected={serviceType === type}
                  onPress={() => setServiceType(type)}
                  style={[
                    styles.chip,
                    serviceType === type && styles.selectedChip
                  ]}
                  textStyle={styles.chipText}
                >
                  {type}
                </Chip>
              ))}
            </View>
          </Card.Content>
        </Card>

        {/* Service Description */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Service Description *</Text>
            <TextInput
              label="Describe the work performed"
              value={description}
              onChangeText={setDescription}
              style={styles.input}
              mode="outlined"
              multiline
              numberOfLines={4}
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

        {/* Time and Parts */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Time & Materials</Text>
            <TextInput
              label="Time Spent (hours)"
              value={timeSpent}
              onChangeText={setTimeSpent}
              style={styles.input}
              mode="outlined"
              keyboardType="numeric"
              theme={{
                colors: {
                  primary: '#4CAF50',
                  outline: '#666666',
                  onSurfaceVariant: '#cccccc',
                }
              }}
            />
            <TextInput
              label="Parts Used"
              value={partsUsed}
              onChangeText={setPartsUsed}
              style={[styles.input, styles.inputSpacing]}
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

        {/* Recommendations */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Recommendations</Text>
            <TextInput
              label="Future maintenance or follow-up recommendations"
              value={recommendations}
              onChangeText={setRecommendations}
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

        {/* Status */}
        <Card style={styles.card}>
          <Card.Content>
            <Text style={styles.sectionTitle}>Report Status</Text>
            <View style={styles.statusContainer}>
              {statusOptions.map((status) => (
                <Chip
                  key={status.value}
                  selected={reportStatus === status.value}
                  onPress={() => setReportStatus(status.value)}
                  style={[
                    styles.statusChip,
                    reportStatus === status.value && {
                      backgroundColor: `${status.color}20`,
                      borderColor: status.color,
                      borderWidth: 1,
                    }
                  ]}
                  textStyle={[
                    styles.chipText,
                    reportStatus === status.value && { color: status.color }
                  ]}
                >
                  {status.label}
                </Chip>
              ))}
            </View>
          </Card.Content>
        </Card>

        {/* Action Buttons */}
        <View style={styles.buttonContainer}>
          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Signature')}
            style={styles.signatureButton}
            labelStyle={styles.buttonLabel}
            icon="create"
          >
            Add Signature
          </Button>

          <Button
            mode="contained"
            onPress={handleSaveReport}
            style={styles.saveButton}
            labelStyle={styles.saveButtonLabel}
            icon="content-save"
          >
            Save Report
          </Button>
        </View>

        {/* Quick Stats */}
        <Card style={styles.statsCard}>
          <Card.Content>
            <Text style={styles.statsTitle}>Today's Reports</Text>
            <View style={styles.statsRow}>
              <View style={styles.statItem}>
                <Ionicons name="checkmark-circle" size={24} color="#4CAF50" />
                <Text style={styles.statNumber}>6</Text>
                <Text style={styles.statLabel}>Completed</Text>
              </View>
              <View style={styles.statItem}>
                <Ionicons name="time" size={24} color="#FF9800" />
                <Text style={styles.statNumber}>3</Text>
                <Text style={styles.statLabel}>In Progress</Text>
              </View>
              <View style={styles.statItem}>
                <Ionicons name="alert-circle" size={24} color="#F44336" />
                <Text style={styles.statNumber}>1</Text>
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
  inputSpacing: {
    marginTop: 16,
  },
  chipContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  chip: {
    backgroundColor: '#2a2a2a',
    marginBottom: 8,
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
  statusContainer: {
    gap: 8,
  },
  statusChip: {
    backgroundColor: '#2a2a2a',
    marginBottom: 8,
    alignSelf: 'flex-start',
  },
  buttonContainer: {
    flexDirection: 'row',
    gap: 12,
    marginVertical: 16,
  },
  signatureButton: {
    flex: 1,
    borderColor: '#4CAF50',
    borderRadius: 8,
  },
  saveButton: {
    flex: 2,
    backgroundColor: '#4CAF50',
    borderRadius: 8,
  },
  buttonLabel: {
    fontFamily: 'SpaceGrotesk-Medium',
    color: '#4CAF50',
  },
  saveButtonLabel: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    color: '#ffffff',
  },
  statsCard: {
    marginVertical: 16,
    marginBottom: 32,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
  },
  statsTitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 16,
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
    gap: 4,
  },
  statNumber: {
    fontFamily: 'SpaceGrotesk-Bold',
    fontSize: 18,
    color: '#ffffff',
  },
  statLabel: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 11,
    color: '#cccccc',
  },
});

export default ServiceReportScreen;
