import React, { useState, useRef } from 'react';
import { View, StyleSheet, Alert, Dimensions } from 'react-native';
import { Text, Card, Button } from 'react-native-paper';
import SignatureCanvas from 'react-native-signature-canvas';

const { width, height } = Dimensions.get('window');

const SignatureScreen = () => {
  const [signature, setSignature] = useState(null);
  const [customerName, setCustomerName] = useState('John Smith');
  const ref = useRef();

  const handleOK = (signature) => {
    setSignature(signature);
    Alert.alert('Signature Captured!', 'Digital signature has been saved successfully.');
  };

  const handleEmpty = () => {
    Alert.alert('Empty Signature', 'Please provide a signature before saving.');
  };

  const handleClear = () => {
    ref.current.clearSignature();
    setSignature(null);
  };

  const handleConfirm = () => {
    ref.current.readSignature();
  };

  const style = `
    .m-signature-pad {
      box-shadow: none;
      border: none;
      background-color: #2a2a2a;
      border-radius: 12px;
    }
    .m-signature-pad--body {
      border: none;
      background-color: #2a2a2a;
    }
    .m-signature-pad--footer {
      display: none;
    }
    body,html {
      width: 100%;
      height: 100%;
      background-color: #2a2a2a;
    }
  `;

  return (
    <View style={styles.container}>
      {/* Header Card */}
      <Card style={styles.headerCard}>
        <Card.Content>
          <Text style={styles.title}>Digital Signature</Text>
          <Text style={styles.subtitle}>Customer: {customerName}</Text>
          <Text style={styles.instruction}>
            Please sign below to acknowledge service completion
          </Text>
        </Card.Content>
      </Card>

      {/* Signature Pad */}
      <Card style={styles.signatureCard}>
        <Card.Content style={styles.signatureContent}>
          <View style={styles.signatureContainer}>
            <SignatureCanvas
              ref={ref}
              onOK={handleOK}
              onEmpty={handleEmpty}
              descriptionText=""
              clearText="Clear"
              confirmText="Save"
              webStyle={style}
              penColor="#4CAF50"
              backgroundColor="#2a2a2a"
              style={styles.signaturePad}
            />
          </View>
          
          <View style={styles.signatureLabel}>
            <Text style={styles.signatureLabelText}>Customer Signature</Text>
            <View style={styles.signatureLine} />
          </View>
        </Card.Content>
      </Card>

      {/* Action Buttons */}
      <View style={styles.buttonContainer}>
        <Button
          mode="outlined"
          onPress={handleClear}
          style={styles.clearButton}
          labelStyle={styles.clearButtonLabel}
          icon="eraser"
        >
          Clear
        </Button>

        <Button
          mode="contained"
          onPress={handleConfirm}
          style={styles.saveButton}
          labelStyle={styles.saveButtonLabel}
          icon="check"
        >
          Save Signature
        </Button>
      </View>

      {/* Info Card */}
      <Card style={styles.infoCard}>
        <Card.Content>
          <Text style={styles.infoTitle}>Signature Details</Text>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Date:</Text>
            <Text style={styles.infoValue}>{new Date().toLocaleDateString()}</Text>
          </View>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Time:</Text>
            <Text style={styles.infoValue}>{new Date().toLocaleTimeString()}</Text>
          </View>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Technician:</Text>
            <Text style={styles.infoValue}>TAD Service Team</Text>
          </View>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Status:</Text>
            <Text style={[styles.infoValue, { color: signature ? '#4CAF50' : '#FF9800' }]}>
              {signature ? 'Signed' : 'Awaiting Signature'}
            </Text>
          </View>
        </Card.Content>
      </Card>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#121212',
    paddingHorizontal: 16,
  },
  headerCard: {
    marginVertical: 16,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
    elevation: 4,
  },
  title: {
    fontFamily: 'SpaceGrotesk-Bold',
    fontSize: 24,
    color: '#ffffff',
    textAlign: 'center',
    marginBottom: 8,
  },
  subtitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 16,
    color: '#4CAF50',
    textAlign: 'center',
    marginBottom: 8,
  },
  instruction: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#cccccc',
    textAlign: 'center',
    lineHeight: 20,
  },
  signatureCard: {
    flex: 1,
    marginVertical: 8,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
    elevation: 4,
  },
  signatureContent: {
    flex: 1,
    padding: 16,
  },
  signatureContainer: {
    flex: 1,
    backgroundColor: '#2a2a2a',
    borderRadius: 12,
    overflow: 'hidden',
    minHeight: 250,
  },
  signaturePad: {
    flex: 1,
    backgroundColor: '#2a2a2a',
  },
  signatureLabel: {
    alignItems: 'center',
    marginTop: 16,
  },
  signatureLabelText: {
    fontFamily: 'SpaceGrotesk-Medium',
    fontSize: 14,
    color: '#cccccc',
    marginBottom: 8,
  },
  signatureLine: {
    width: 200,
    height: 1,
    backgroundColor: '#666666',
  },
  buttonContainer: {
    flexDirection: 'row',
    gap: 12,
    marginVertical: 16,
  },
  clearButton: {
    flex: 1,
    borderColor: '#F44336',
    borderRadius: 8,
  },
  clearButtonLabel: {
    fontFamily: 'SpaceGrotesk-Medium',
    color: '#F44336',
  },
  saveButton: {
    flex: 2,
    backgroundColor: '#4CAF50',
    borderRadius: 8,
  },
  saveButtonLabel: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    color: '#ffffff',
  },
  infoCard: {
    marginBottom: 16,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
    elevation: 4,
  },
  infoTitle: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 16,
    color: '#ffffff',
    marginBottom: 16,
    textAlign: 'center',
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  infoLabel: {
    fontFamily: 'SpaceGrotesk-Medium',
    fontSize: 14,
    color: '#cccccc',
  },
  infoValue: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#ffffff',
  },
});

export default SignatureScreen;
