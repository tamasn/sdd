#!/bin/bash
# Read a JIRA ticket via REST API
# Usage: read-jira.sh PROJ-1234
# Requires: JIRA_URL, JIRA_EMAIL, JIRA_API_TOKEN environment variables

set -euo pipefail
TICKET=$1
JIRA_URL="${JIRA_URL:-https://jira.atlassian.net}"
curl -sf -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  "$JIRA_URL/rest/api/3/issue/$TICKET?fieldsByKeys=true&fields=*all&properties=*all&expand=renderedFields,names" | \
  jq '{
      key: .key,
      summary: .fields.summary,
      description: .renderedFields.description,
      status: .fields.status.name,
      assignee: .fields.assignee.displayName,
      labels: .fields.labels,
    }'
