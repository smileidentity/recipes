import React, { useState } from 'react';
import {
    View,
    Text,
    ScrollView,
    StatusBar,
    StyleSheet,
    Pressable,
} from 'react-native';

import DocumentVerificationView  from './specs/DocumentVerificationNativeComponent.ts';

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

function App(): React.JSX.Element {
    const [currentScreen, setCurrentScreen] = useState<'home' | 'document'>('home');

    return (
        <View style={styles.container}>
            <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />
            {currentScreen === 'home' ? (
                <ScrollView contentContainerStyle={styles.scrollContainer}>
                    <Text style={styles.header}>Smile ID Demos</Text>
                    <Card onPress={() => setCurrentScreen('document')}>
                        <Text style={styles.cardTitle}>Document Verification</Text>
                        <Text style={styles.cardContent}>Tap to start verification</Text>
                    </Card>
                    <Card onPress={() => setCurrentScreen('document')}>
                        <Text style={styles.cardTitle}>Another Flow</Text>
                        <Text style={styles.cardContent}>Also opens native view</Text>
                    </Card>
                </ScrollView>
            ) : (
                <View style={styles.nativeViewContainer}>
                    <Pressable onPress={() => setCurrentScreen('home')} style={styles.backButton}>
                        <Text style={styles.backButtonText}>← Back</Text>
                    </Pressable>
                    <DocumentVerificationView style={styles.nativeView} />
                </View>
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#ffffff',
        flex: 1,
    },
    scrollContainer: {
        padding: 20,
    },
    header: {
        fontSize: 22,
        fontWeight: '700',
        marginBottom: 20,
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
    nativeViewContainer: {
        flex: 1,
    },
    backButton: {
        padding: 16,
        backgroundColor: '#eeeeee',
    },
    backButtonText: {
        color: '#333',
        fontSize: 16,
    },
    nativeView: {
        flex: 1,
    },
});

export default App;
