import {
  View,
  StyleSheet,
  StatusBar,
  Animated,
  Text,
  Pressable,
} from 'react-native';
import {
  SafeAreaProvider,
  SafeAreaView,
  useSafeAreaInsets,
} from 'react-native-safe-area-context';
import {
  DocumentVerificationView,
  SmartSelfieAuthenticationView,
  SmartSelfieEnrollmentView,
  RnWrapperRecipeView,
  initialize,
} from 'react-native-rn-wrapper-recipe';
import { useEffect, useState } from 'react';
import ScrollView = Animated.ScrollView;

function Header({ title, onBack }: { title: string; onBack?: () => void }) {
  const insets = useSafeAreaInsets();
  return (
    <View
      style={[
        styles.headerContainer,
        { paddingTop: insets.top, height: 56 + insets.top },
      ]}
    >
      {onBack ? (
        <Pressable onPress={onBack} style={styles.headerButton}>
          <Text style={styles.headerButtonText}>←</Text>
        </Pressable>
      ) : (
        <View style={styles.headerButton} />
      )}
      <Text style={styles.headerTitle}>{title}</Text>
      <View style={styles.headerButton} />
    </View>
  );
}

function Card({
  children,
  onPress,
}: React.PropsWithChildren<{ onPress: () => void }>) {
  return (
    <Pressable onPress={onPress} style={styles.card}>
      {children}
    </Pressable>
  );
}

export default function App(): React.JSX.Element {
  const [currentScreen, setCurrentScreen] = useState<
    | 'home'
    | 'documentVerification'
    | 'smartSelfieEnrollment'
    | 'smartSelfieAuthentication'
    | 'another'
  >('home');

  // Initialize the SmileID SDK once at app start
  useEffect(() => {
    const setupSmileID = async () => {
      try {
        const config = {
          partner_id: 'YOUR_PARTNER_ID',
          auth_token: 'YOUR_AUTH_TOKEN',
          prod_lambda_url: 'https://your-prod-lambda-url',
          test_lambda_url: 'https://your-test-lambda-url',
        };
        // await initialize(false, false, config, "your_api_key");
        // await initialize(false, false, config); // Uncomment this when testing iOS
        await initialize(false, false); // use this for Android - with your smile_id config in asset folder
        console.log('[SmileID] SDK initialized');
        // Optionally set a callback URL if needed:
        // await setCallbackUrl('https://your.server/callback');
      } catch (error) {
        console.error('[SmileID] Setup failed:', error);
      }
    };
    setupSmileID();
  }, []);

  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.container} edges={['bottom']}>
        <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />

        {currentScreen === 'home' && (
          <>
            <Header title="Smile ID Demos" />
            <ScrollView contentContainerStyle={styles.scrollContainer}>
              <Card onPress={() => setCurrentScreen('documentVerification')}>
                <Text style={styles.cardTitle}>Document Verification</Text>
                <Text style={styles.cardContent}>
                  Tap to start verification
                </Text>
              </Card>
              <Card onPress={() => setCurrentScreen('smartSelfieEnrollment')}>
                <Text style={styles.cardTitle}>Smart Selfie Enrollment</Text>
                <Text style={styles.cardContent}>Tap to start enrollment</Text>
              </Card>
              <Card
                onPress={() => setCurrentScreen('smartSelfieAuthentication')}
              >
                <Text style={styles.cardTitle}>
                  Smart Selfie Authentication
                </Text>
                <Text style={styles.cardContent}>
                  Tap to start authentication
                </Text>
              </Card>
              <Card onPress={() => setCurrentScreen('another')}>
                <Text style={styles.cardTitle}>Default Flow</Text>
                <Text style={styles.cardContent}>
                  Also opens default native view
                </Text>
              </Card>
            </ScrollView>
          </>
        )}

        {currentScreen === 'documentVerification' && (
          <>
            <Header
              title="Document Verification"
              onBack={() => setCurrentScreen('home')}
            />
            <DocumentVerificationView
              onSuccess={(e) => {
                const {
                  selfie,
                  documentFrontFile,
                  documentBackFile,
                  didSubmitDocumentVerificationJob,
                } = e.nativeEvent;
                // handle success
                console.log('RNWrapperRecipeSuccess:', {
                  selfie,
                  documentFrontFile,
                  documentBackFile,
                  didSubmitDocumentVerificationJob,
                });
                // navigate to home
                setCurrentScreen('home');
              }}
              onError={(e) => {
                const { message, code } = e.nativeEvent;
                // handle error
                console.error('Error:', { message, code });
                // navigate to home
                setCurrentScreen('home');
              }}
              style={styles.nativeView}
            />
          </>
        )}

        {currentScreen === 'smartSelfieEnrollment' && (
          <>
            <Header
              title="Smart Selfie Enrollment"
              onBack={() => setCurrentScreen('home')}
            />
            <SmartSelfieEnrollmentView
              style={styles.nativeView}
              onSuccess={(e) => {
                try {
                  const payload = JSON.parse(e.nativeEvent.result);
                  console.log('SmartSelfieEnroll success:', payload);
                } catch (err) {
                  console.warn(
                    'SmartSelfieEnroll success (non-JSON):',
                    e.nativeEvent.result
                  );
                }
                setCurrentScreen('home');
              }}
              onError={(e) => {
                console.error('SmartSelfieEnroll error:', e.nativeEvent.error);
                setCurrentScreen('home');
              }}
            />
          </>
        )}

        {currentScreen === 'smartSelfieAuthentication' && (
          <>
            <Header
              title="Smart Selfie Authentication"
              onBack={() => setCurrentScreen('home')}
            />
            <SmartSelfieAuthenticationView
              style={styles.nativeView}
              onSuccess={(e) => {
                try {
                  const payload = JSON.parse(e.nativeEvent.result);
                  console.log('SmartSelfieAuth success:', payload);
                } catch (err) {
                  console.warn(
                    'SmartSelfieAuth success (non-JSON):',
                    e.nativeEvent.result
                  );
                }
                setCurrentScreen('home');
              }}
              onError={(e) => {
                console.error('SmartSelfieAuth error:', e.nativeEvent.error);
                setCurrentScreen('home');
              }}
            />
          </>
        )}

        {currentScreen === 'another' && (
          <>
            <Header
              title="Another Flow"
              onBack={() => setCurrentScreen('home')}
            />
            <RnWrapperRecipeView color="#ff6347" style={styles.nativeView} />
          </>
        )}
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#ffffff',
    flex: 1,
  },
  headerContainer: {
    // Height is combined with dynamic top inset in Header component
    height: 56,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    backgroundColor: '#ffffff',
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#ccc',
  },
  headerButton: {
    padding: 8,
    width: 40,
    alignItems: 'flex-start',
  },
  headerButtonText: {
    fontSize: 20,
    color: '#007AFF',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    flex: 1,
  },
  scrollContainer: {
    padding: 20,
  },
  card: {
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#ddd',
    marginBottom: 16,
    backgroundColor: '#f9f9f9',
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: 2 },
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
  nativeView: {
    flex: 1,
  },
});
