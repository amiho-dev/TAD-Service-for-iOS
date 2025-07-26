import React, { useState } from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import { Text, Searchbar, Card, Avatar, Chip } from 'react-native-paper';
import { Ionicons } from '@expo/vector-icons';

const CustomerSearchScreen = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [customers] = useState([
    {
      id: '1',
      name: 'John Smith',
      company: 'Smith Electronics',
      phone: '+1 (555) 123-4567',
      email: 'john@smithelectronics.com',
      address: '123 Main St, City, State 12345',
      status: 'Active',
      lastService: '2024-01-15'
    },
    {
      id: '2',
      name: 'Sarah Johnson',
      company: 'Tech Solutions Inc',
      phone: '+1 (555) 987-6543',
      email: 'sarah@techsolutions.com',
      address: '456 Oak Ave, City, State 67890',
      status: 'Active',
      lastService: '2024-01-10'
    },
    {
      id: '3',
      name: 'Mike Chen',
      company: 'Digital Dynamics',
      phone: '+1 (555) 555-0123',
      email: 'mike@digitaldynamics.com',
      address: '789 Pine Rd, City, State 54321',
      status: 'Pending',
      lastService: '2024-01-05'
    }
  ]);

  const filteredCustomers = customers.filter(customer =>
    customer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    customer.company.toLowerCase().includes(searchQuery.toLowerCase()) ||
    customer.phone.includes(searchQuery) ||
    customer.email.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const renderCustomer = ({ item }) => (
    <Card style={styles.customerCard}>
      <Card.Content>
        <View style={styles.customerHeader}>
          <Avatar.Text 
            size={50} 
            label={item.name.split(' ').map(n => n[0]).join('')}
            style={styles.avatar}
          />
          <View style={styles.customerInfo}>
            <Text style={styles.customerName}>{item.name}</Text>
            <Text style={styles.companyName}>{item.company}</Text>
            <Chip 
              mode="outlined" 
              style={[styles.statusChip, 
                item.status === 'Active' ? styles.activeChip : styles.pendingChip
              ]}
              textStyle={styles.chipText}
            >
              {item.status}
            </Chip>
          </View>
        </View>
        
        <View style={styles.contactInfo}>
          <View style={styles.contactRow}>
            <Ionicons name="call" size={16} color="#4CAF50" />
            <Text style={styles.contactText}>{item.phone}</Text>
          </View>
          <View style={styles.contactRow}>
            <Ionicons name="mail" size={16} color="#4CAF50" />
            <Text style={styles.contactText}>{item.email}</Text>
          </View>
          <View style={styles.contactRow}>
            <Ionicons name="location" size={16} color="#4CAF50" />
            <Text style={styles.contactText}>{item.address}</Text>
          </View>
          <View style={styles.contactRow}>
            <Ionicons name="time" size={16} color="#4CAF50" />
            <Text style={styles.contactText}>Last service: {item.lastService}</Text>
          </View>
        </View>
      </Card.Content>
    </Card>
  );

  return (
    <View style={styles.container}>
      <View style={styles.searchContainer}>
        <Searchbar
          placeholder="Search customers..."
          onChangeText={setSearchQuery}
          value={searchQuery}
          style={styles.searchbar}
          inputStyle={styles.searchInput}
          iconColor="#4CAF50"
        />
      </View>

      <FlatList
        data={filteredCustomers}
        renderItem={renderCustomer}
        keyExtractor={item => item.id}
        style={styles.list}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Ionicons name="search" size={64} color="#666666" />
            <Text style={styles.emptyText}>No customers found</Text>
            <Text style={styles.emptySubtext}>Try adjusting your search criteria</Text>
          </View>
        }
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#121212',
  },
  searchContainer: {
    padding: 16,
  },
  searchbar: {
    backgroundColor: '#1e1e1e',
    borderRadius: 12,
  },
  searchInput: {
    fontFamily: 'SpaceGrotesk-Regular',
    color: '#ffffff',
  },
  list: {
    flex: 1,
    paddingHorizontal: 16,
  },
  customerCard: {
    marginBottom: 12,
    borderRadius: 12,
    backgroundColor: '#1e1e1e',
    elevation: 4,
  },
  customerHeader: {
    flexDirection: 'row',
    marginBottom: 16,
  },
  avatar: {
    backgroundColor: '#4CAF50',
    marginRight: 16,
  },
  customerInfo: {
    flex: 1,
    justifyContent: 'center',
  },
  customerName: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 18,
    color: '#ffffff',
    marginBottom: 4,
  },
  companyName: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#cccccc',
    marginBottom: 8,
  },
  statusChip: {
    alignSelf: 'flex-start',
  },
  activeChip: {
    backgroundColor: '#4CAF5020',
    borderColor: '#4CAF50',
  },
  pendingChip: {
    backgroundColor: '#FF980020',
    borderColor: '#FF9800',
  },
  chipText: {
    fontFamily: 'SpaceGrotesk-Medium',
    fontSize: 12,
  },
  contactInfo: {
    gap: 8,
  },
  contactRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  contactText: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#cccccc',
    flex: 1,
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 80,
  },
  emptyText: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 18,
    color: '#ffffff',
    marginTop: 16,
  },
  emptySubtext: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: '#666666',
    marginTop: 8,
  },
});

export default CustomerSearchScreen;
