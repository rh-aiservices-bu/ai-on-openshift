# Configuring TrustyAI Guardrails Orchestrator with HTTPS and API Key Authentication

When deploying the TrustyAI Guardrails Orchestrator in production environments, you'll often need to connect to external LLM services that require HTTPS and API key authentication. This guide shows you how to configure the orchestrator for these scenarios, whether you're using Models as a Service (MaaS), OpenAI, Google Gemini, or other hosted LLM providers.

## Background

The [Lemonade Stand Assistant quickstart](https://github.com/rh-ai-quickstart/lemonade-stand-assistant) demonstrates a simple deployment where all services run within the same OpenShift AI cluster using HTTP. However, production deployments often require:

- **HTTPS connections** to external model endpoints
- **API key authentication** for commercial LLM services
- **Certificate management** for secure communications

## Configuration Overview

The orchestrator configuration is managed through a ConfigMap that specifies:

1. **Service endpoints** - Where to connect for LLM inference
2. **TLS settings** - How to handle HTTPS connections
3. **Header passthrough** - Which headers to forward (including authorization)

## Basic HTTP Configuration (Local Deployment)

Here's the simple configuration from the Lemonade Stand Assistant, which uses HTTP within the cluster:

```yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: fms-orchestr8-config-nlp
data:
  config.yaml: |
    openai:
      service:
        hostname: llama-32-predictor
        port: 80
    detectors:
      hap:
        type: text_contents
        service:
          hostname: guardrails-detector-ibm-hap-predictor
          port: 80
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
```

This works fine for local cluster services, but external APIs require HTTPS and authentication.

## HTTPS with API Key Configuration (External Services)

When connecting to external LLM services like OpenAI, Azure OpenAI, Google Gemini, or other MaaS providers, you need to configure both TLS and authentication headers:

```yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: fms-orchestr8-config-nlp
data:
  config.yaml: |
    passthrough_headers:
      - authorization
    openai:
      service:
        hostname: api.openai.com
        port: 443
        tls: external_llm
    detectors:
      hap:
        type: text_contents
        service:
          hostname: guardrails-detector-ibm-hap-predictor
          port: 80
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
    tls:
      external_llm:
        insecure: true
        cert_path: /dev/null
```

### Key Configuration Elements

#### 1. Passthrough Headers

```yaml
passthrough_headers:
  - authorization
```

This tells the orchestrator to forward the `Authorization` header from client requests to the LLM service. This is how your API keys are passed through.

**Usage in client requests:**

```bash
curl -H "Authorization: Bearer sk-your-api-key-here" \
     -H "Content-Type: application/json" \
     --request POST \
     --data '{"model": "llama32", "messages": [{"role": "user", "content": "Hello"}]}' \
     https://your-orchestrator-endpoint/all/v1/chat/completions
```

#### 2. Service Configuration with HTTPS

```yaml
openai:
  service:
    hostname: api.openai.com
    port: 443
    tls: external_llm
```

- `hostname`: The external LLM service endpoint
- `port: 443`: Standard HTTPS port
- `tls: external_llm`: References the TLS configuration (defined below)

#### 3. TLS Configuration

The orchestrator has a unique requirement: even when connecting to services with trusted certificates, you must provide a TLS configuration. Here's how to handle it:

**For services with trusted certificates (OpenAI, Azure, etc.):**

```yaml
tls:
  external_llm:
    insecure: true
    cert_path: /dev/null
```

- `insecure: true`: Disables certificate verification while still using HTTPS/TLS encryption. This allows connecting to services with self-signed certificates or when you don't want to provide a custom CA certificate. The connection is still encrypted, but the server's certificate is not validated.
- `cert_path: /dev/null`: Dummy path required by the orchestrator configuration parser (required even when `insecure: true`)

**For services with custom certificates:**

```yaml
tls:
  external_llm:
    cert_path: /path/to/tls.crt
    key_path: /path/to/tls.key
    client_ca_cert_path: /path/to/ca.crt
    insecure: false
```

- `cert_path`: Path to the client certificate
- `key_path`: Path to the client private key
- `client_ca_cert_path`: Path to the Certificate Authority certificate
- `insecure: false`: Enforces certificate validation


## Complete Example with Multiple Detectors

Here's an example configuration that combines external LLM with local detectors:

```yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: fms-orchestr8-config-nlp
  annotations:
    helm.sh/weight: "0"
data:
  config.yaml: |
    passthrough_headers:
      - authorization
    openai:
      service:
        hostname: your-maas-endpoint.com
        port: 443
        tls: external_llm
    detectors:
      regex_competitor:
        type: text_contents
        service:
          hostname: "127.0.0.1"
          port: 8080
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
      hap:
        type: text_contents
        service:
          hostname: guardrails-detector-ibm-hap-predictor
          port: 80
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
      prompt_injection:
        type: text_contents
        service:
          hostname: prompt-injection-detector-predictor
          port: 80
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
      language_detection:
        type: text_contents
        service:
          hostname: language-detector-predictor
          port: 80
        chunker_id: whole_doc_chunker
        default_threshold: 0.5
    tls:
      external_llm:
        insecure: true
        cert_path: /dev/null
```

## Security Considerations

1. **API Key Management**: Store API keys securely using Kubernetes Secrets or other secret management tools, not plain text
2. **TLS Validation**: Only use `insecure: true` when connecting to services with publicly trusted certificates
3. **Header Filtering**: Only include necessary headers in `passthrough_headers`
4. **Network Policies**: Implement network policies to restrict egress traffic to authorized endpoints

## Conclusion

Use this configuration as a starting point for your production deployments with external LLM services, and adjust based on your specific provider's requirements.
