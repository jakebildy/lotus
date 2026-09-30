import axios from "axios";
import crypto from "crypto";

const FACEBOOK_PIXEL_ID = process.env.FACEBOOK_PIXEL_ID;
const ACCESS_TOKEN = process.env.FACEBOOK_ACCESS_TOKEN;

const CONVERSIONS_API_URL = `https://graph.facebook.com/v21.0/${FACEBOOK_PIXEL_ID}/events`;

interface ConversionEvent {
  event_name: string;
  event_time: number;
  user_data: {
    em: string; // Email hash (SHA256) in lowercase
  };
  custom_data?: Record<string, unknown>;
  event_source_url?: string; // Optional, URL where the event occurred
  action_source?: string; // Example: "website", "app"
}

const sendEvent = async (event: ConversionEvent): Promise<void> => {
  try {
    const response = await axios.post(
      CONVERSIONS_API_URL,
      {
        data: [event],
      },
      {
        headers: {
          Authorization: `Bearer ${ACCESS_TOKEN}`,
          "Content-Type": "application/json",
        },
      },
    );
    console.log(`Event ${event.event_name} sent successfully:`, response.data);
  } catch (error: any) {
    console.error(
      `Error sending ${event.event_name} event:`,
      error.response?.data || error.message,
    );
  }
};

// Hash an email address (SHA256) the way the Conversions API expects it.
const hashEmail = (email: string): string => {
  return crypto
    .createHash("sha256")
    .update(email.toLowerCase().trim())
    .digest("hex");
};

const trackEvent = async (eventName: string, email: string): Promise<void> => {
  const event: ConversionEvent = {
    event_name: eventName,
    event_time: Math.floor(Date.now() / 1000),
    user_data: {
      em: hashEmail(email),
    },
    action_source: "app",
  };
  await sendEvent(event);
};

export const trackSignup = async (email: string): Promise<void> => {
  await trackEvent("Signup", email);
};

export const trackStartTrial = async (email: string): Promise<void> => {
  await trackEvent("StartTrial", email);
};
