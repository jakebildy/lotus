# Fits Backend Documentation
Welcome to the Fits backend documentation. 
This is still a work in progress, but this is where information will be found on how to run the various services, as well as how they work.

## Getting Started
To run the backend locally, first ensure you have the environment variables (locate the .env file, or ask for it to be provided). Then do
```npm run dev```

## Running Stripe locally
```stripe listen --forward-to localhost:8000/api/stripe/webhook```