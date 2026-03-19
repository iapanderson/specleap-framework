#!/bin/bash
# openspec jira — Jira integration for SDD workflow
# SCRUM-23: Integrar Jira como origen del flujo SDD (Ticket → Spec → Code)
# Usage: openspec jira <command> [args]

set -e

JIRA_BASE="https://ia-conceptualcreative.atlassian.net"
JIRA_EMAIL="p.anderson@conceptualcreative.com"
JIRA_TOKEN=$(security find-generic-password -s "jira-conceptualcreative" -w 2>/dev/null)

if [[ -z "$JIRA_TOKEN" ]]; then
  echo "Error: Jira token not found in Keychain."
  echo "Store it with: security add-generic-password -s jira-conceptualcreative -a <email> -w <token>"
  exit 1
fi

B64=$(echo -n "$JIRA_EMAIL:$JIRA_TOKEN" | base64)

jira_api() {
  local method="${1:-GET}"
  local endpoint="$2"
  local data="$3"
  
  if [[ -n "$data" ]]; then
    curl -s -X "$method" "$JIRA_BASE$endpoint" \
      -H "Authorization: Basic $B64" \
      -H "Content-Type: application/json" \
      -d "$data"
  else
    curl -s -X "$method" "$JIRA_BASE$endpoint" \
      -H "Authorization: Basic $B64" \
      -H "Content-Type: application/json"
  fi
}

case "$1" in
  ls|list)
    # List open issues
    STATUS="${2:-open}"
    JQL="project=SCRUM AND status not in ('Finalizada') ORDER BY key ASC"
    jira_api POST "/rest/api/3/search/jql" \
      "{\"jql\": \"$JQL\", \"maxResults\": 50, \"fields\": [\"summary\",\"status\",\"issuetype\",\"priority\"]}" | \
      python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'Issues abiertas: {len(data.get(\"issues\", []))}\n')
for i in data.get('issues', []):
    key = i['key']
    summary = i['fields']['summary']
    status = i['fields']['status']['name']
    itype = i['fields']['issuetype']['name']
    print(f'  {key:10} [{status:20}] {summary}')
"
    ;;

  show)
    # Show issue details
    ISSUE="$2"
    if [[ -z "$ISSUE" ]]; then echo "Usage: openspec jira show <SCRUM-X>"; exit 1; fi
    jira_api GET "/rest/api/3/issue/$ISSUE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
f = data['fields']
print(f\"Key:         {data['key']}\")
print(f\"Summary:     {f['summary']}\")
print(f\"Status:      {f['status']['name']}\")
print(f\"Type:        {f['issuetype']['name']}\")
print(f\"Priority:    {f.get('priority', {}).get('name', 'N/A')}\")
desc = f.get('description')
if desc:
    content = desc.get('content', [])
    for block in content:
        for item in block.get('content', []):
            if item.get('type') == 'text':
                print(item.get('text', ''))
"
    ;;

  start)
    # Start working on an issue (transition to En curso)
    ISSUE="$2"
    if [[ -z "$ISSUE" ]]; then echo "Usage: openspec jira start <SCRUM-X>"; exit 1; fi
    # Get available transitions
    TRANSITIONS=$(jira_api GET "/rest/api/3/issue/$ISSUE/transitions")
    TRANSITION_ID=$(echo "$TRANSITIONS" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('transitions', []):
    if 'curso' in t['name'].lower() or 'progress' in t['name'].lower():
        print(t['id'])
        break
")
    if [[ -n "$TRANSITION_ID" ]]; then
      jira_api POST "/rest/api/3/issue/$ISSUE/transitions" \
        "{\"transition\": {\"id\": \"$TRANSITION_ID\"}}" > /dev/null
      echo "✅ $ISSUE → En curso"
    else
      echo "No se encontró transición 'En curso' para $ISSUE"
    fi
    # Create branch following convention: feature/SCRUM-X-description
    SUMMARY=$(jira_api GET "/rest/api/3/issue/$ISSUE" | python3 -c "
import json, sys, re
data = json.load(sys.stdin)
s = data['fields']['summary'].lower()
s = re.sub(r'[^a-z0-9\s-]', '', s)
s = re.sub(r'\s+', '-', s.strip())
print(s[:50])
")
    BRANCH="feature/$ISSUE-$SUMMARY"
    git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"
    echo "🌿 Branch: $BRANCH"
    ;;

  done)
    # Mark issue as done
    ISSUE="$2"
    if [[ -z "$ISSUE" ]]; then echo "Usage: openspec jira done <SCRUM-X>"; exit 1; fi
    TRANSITIONS=$(jira_api GET "/rest/api/3/issue/$ISSUE/transitions")
    TRANSITION_ID=$(echo "$TRANSITIONS" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('transitions', []):
    if 'finaliz' in t['name'].lower() or 'done' in t['name'].lower():
        print(t['id'])
        break
")
    if [[ -n "$TRANSITION_ID" ]]; then
      jira_api POST "/rest/api/3/issue/$ISSUE/transitions" \
        "{\"transition\": {\"id\": \"$TRANSITION_ID\"}}" > /dev/null
      echo "✅ $ISSUE → Finalizada"
    else
      echo "No se encontró transición 'Finalizada' para $ISSUE"
    fi
    ;;

  branch)
    # Show expected branch name for an issue
    ISSUE="$2"
    if [[ -z "$ISSUE" ]]; then echo "Usage: openspec jira branch <SCRUM-X>"; exit 1; fi
    SUMMARY=$(jira_api GET "/rest/api/3/issue/$ISSUE" | python3 -c "
import json, sys, re
data = json.load(sys.stdin)
s = data['fields']['summary'].lower()
s = re.sub(r'[^a-z0-9\s-]', '', s)
s = re.sub(r'\s+', '-', s.strip())
print(s[:50])
")
    echo "feature/$ISSUE-$SUMMARY"
    ;;

  *)
    echo "openspec jira — Jira integration for SDD"
    echo ""
    echo "Usage: openspec jira <command>"
    echo ""
    echo "Commands:"
    echo "  ls              List open issues"
    echo "  show <SCRUM-X>  Show issue details"
    echo "  start <SCRUM-X> Start issue (transition + create branch)"
    echo "  done <SCRUM-X>  Mark issue as done"
    echo "  branch <SCRUM-X> Show expected branch name"
    ;;
esac
