#!/bin/bash

# Variables
PROJECT_ID="mejuribluepill"
SERVICE_ACCOUNT_NAME="github-actions-sa"
KEY_FILE="gcp-sa-key.json"
ROLE="roles/editor"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
  echo "gcloud CLI is not installed. Please install it first."
  exit 1
fi

# Authenticate gcloud
gcloud auth login

# Set the project
gcloud config set project $PROJECT_ID

# Create the service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name "Service Account for GitHub Actions"

# Get the service account email
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \
  --filter="displayName:Service Account for GitHub Actions" \
  --format="value(email)")

# Assign roles to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role=$ROLE

# Create and download the JSON key
gcloud iam service-accounts keys create $KEY_FILE \
  --iam-account=$SERVICE_ACCOUNT_EMAIL

echo "Service account created and key downloaded to $KEY_FILE."
echo "Add the content of $KEY_FILE as a GitHub secret named GCP_SA_KEY."