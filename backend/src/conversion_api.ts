import axios from 'axios';

const FACEBOOK_PIXEL_ID = process.env.FACEBOOK_PIXEL_ID; // Replace with your Facebook Pixel ID
const ACCESS_TOKEN = process.env.FACEBOOK_ACCESS_TOKEN; // Replace with your Facebook Access Token

const CONVERSIONS_API_URL = `https://graph.facebook.com/v21.0/${FACEBOOK_PIXEL_ID}/events`;

interface ConversionEvent {
    event_name: string;
    event_time: number;
    user_data: {
        em: string; // Email hash (SHA256) in lowercase
    };
    custom_data?: {
        [key: string]: any;
    };
    event_source_url?: string; // Optional, URL where the event occurred
    action_source?: string; // Example: "website", "app"
}

// Function to send events
const sendEvent = async (event: ConversionEvent) => {
    try {
        const response = await axios.post(CONVERSIONS_API_URL, {
            data: [event],
        }, {
            headers: {
                Authorization: `Bearer ${ACCESS_TOKEN}`,
                'Content-Type': 'application/json',
            },
        });
        console.log(`Event ${event.event_name} sent successfully:`, response.data);
    } catch (error: any) {
        console.error(`Error sending ${event.event_name} event:`, error.response?.data || error.message);
    }
};

// Utility to hash email addresses (SHA256)
const hashEmail = (email: string): string => {
    const crypto = require('crypto');
    return crypto.createHash('sha256').update(email.toLowerCase().trim()).digest('hex');
};

// Track signup event
export const trackSignup = async (email: string) => {
    const event: ConversionEvent = {
        event_name: 'Signup',
        event_time: Math.floor(Date.now() / 1000),
        user_data: {
            em: hashEmail(email),
        },
        action_source: 'app', 
    };
    await sendEvent(event);
};

// Track start trial event
export const trackStartTrial = async (email: string) => {
    const event: ConversionEvent = {
        event_name: 'StartTrial',
        event_time: Math.floor(Date.now() / 1000),
        user_data: {
            em: hashEmail(email),
        },
        action_source: 'app', 
    };
    await sendEvent(event);
};