import React from 'react';
import {
  Text,
  useColorScheme,
  ScrollView,
  StyleSheet,
  Pressable,
} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import {
  Colors,
  Header,
} from 'react-native/Libraries/NewAppScreen';

import DocumentVerificationScreen from './DocumentVerificationScreen';

type RootStackParamList = {
  Home: undefined;
  DocumentVerification: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

function Card({children, onPress}: React.PropsWithChildren<{onPress: () => void}>) {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <Pressable
      onPress={onPress}
      style={[
        styles.card,
        {
          backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
          borderColor: isDarkMode ? Colors.light : Colors.dark,
        },
      ]}>
      {children}
    </Pressable>
  );
}

function HomeScreen({navigation}: {navigation: any}) {
  const isDarkMode = useColorScheme() === 'dark';
  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.black : Colors.white,
  };

  return (
    <ScrollView style={[backgroundStyle, {padding: '5%'}]}>
      <Header />
      <Card onPress={() => navigation.navigate('DocumentVerification')}>
        <Text style={styles.cardTitle}>Verify Documents</Text>
        <Text style={styles.cardContent}>Tap to open DocumentVerificationView</Text>
      </Card>
      <Card onPress={() => navigation.navigate('DocumentVerification')}>
        <Text style={styles.cardTitle}>Another Card</Text>
        <Text style={styles.cardContent}>Also opens DocumentVerificationView</Text>
      </Card>
    </ScrollView>
  );
}

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="DocumentVerification" component={DocumentVerificationScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  card: {
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    marginTop: 16,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowOffset: {width: 0, height: 2},
    shadowRadius: 4,
    elevation: 3,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 8,
  },
  cardContent: {
    fontSize: 14,
    fontWeight: '400',
  },
});
