 # ---- Configuration ----
  KEYCLOAK_URL="https://keycloak.apps.<CLUSTER-DOMAIN>"
  MODEL_NAMESPACE="model-deployment"
  MODEL_NAME="<MODEL-DOMAIN>"
  # -----------------------

  REALM="llm-auth"
  CLIENT_ID="llm-client"
  TOKEN_URL="${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token"

  # Derive the inference base URL from the LLMInferenceService status
  BASE_URL=$(oc get llminferenceservice ${MODEL_NAME} -n ${MODEL_NAMESPACE} \
    -o jsonpath='{.status.addresses[?(@.name=="gateway-external")].url}' \
    | sed "s|/${MODEL_NAMESPACE}/${MODEL_NAME}||")

  INFERENCE_URL="${BASE_URL}/model-deployment/${MODEL_NAME}/v1/chat/completions"

  # Fetch tokens
  ALICE_TOKEN=$(curl -sf -X POST "${TOKEN_URL}" \
    -d "client_id=${CLIENT_ID}" \
    -d "username=alice" \
    -d "password=password" \
    -d "grant_type=password" \
    | jq -r '.access_token')

  BOB_TOKEN=$(curl -sf -X POST "${TOKEN_URL}" \
    -d "client_id=${CLIENT_ID}" \
    -d "username=bob" \
    -d "password=password" \
    -d "grant_type=password" \
    | jq -r '.access_token')

  PAYLOAD="{\"model\":\"${MODEL_NAME}\",\"messages\":[{\"role\":\"user\",\"content\":\"Hello World\"}],\"max_tokens\":50}"

  # Test Alice (has auth-to-model role — expect 200)
  echo "--- Alice ---"
  curl -s -o /dev/null -w "HTTP %{http_code}\n" \
    -X POST "${INFERENCE_URL}" \
    -H "Authorization: Bearer ${ALICE_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}"

  # Test Bob (no auth-to-model role — expect 403)
  echo "--- Bob ---"
  curl -s -o /dev/null -w "HTTP %{http_code}\n" \
    -X POST "${INFERENCE_URL}" \
    -H "Authorization: Bearer ${BOB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}"
