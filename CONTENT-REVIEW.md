# Content review and migration plan for the Field Guides

Branch: `content-review-field-guides` · Review date: 2026-11-24 · Site: ai-on-openshift.io (MkDocs, 72 pages)

**Status: plan only. No page, nav entry or asset has been changed.**

## Scope and method

- Every one of the 72 Markdown pages was read in full, plus `mkdocs.yml`, `docs/theme_override/home.html`, the embedded YAML/manifests, and all 4 relative links that do not resolve.
- Staleness was checked against primary sources: Red Hat OpenShift AI 3.5 release notes (support removals chapter), upstream repositories (last-push dates), vendor docs. Version pins, removed components and deprecated features are quoted where they decide the verdict.
- Criterion: **migrate** only if a reader can follow the page to a concrete outcome and the procedure survives a refresh. **Remove** means nothing reusable remains: marketing, link-only stubs, video tours, pointer pages, or a premise that no longer exists. **Repurpose** is site chrome that is neither a guide nor removable (the homepage).
- Limit: external links were not crawled site-wide (146 GitHub links alone). Dead links beyond those cited may exist.

## Decisions taken (2026-11-24)

| Call | Decision | Effect |
|---|---|---|
| Product baseline | RHOAI 3.x only | ModelMesh/Serverless pages are rewritten or dropped; no 2.x compatibility content |
| Pointer pages | Drop; link the external source once from the relevant guide | 7 pages leave the corpus |
| Guardrails | Drop FMS-based content; a NeMo guide is written only when an owner exists | 3 pages leave; 1 PoC page archived |
| Homepage | Plain index of guides; no marketing hero, no changelog | `home.html` + `whats-new` removed |
| Target | New Field Guides repo/site | This repo freezes with a banner and redirect map |
| Execution | Delete the remove bucket in a second commit | Deferred until the go-ahead; not done today |

## Result

| Verdict | Pages | Share | Meaning |
|---|---:|---:|---|
| Migrate | 37 | 51% | Hands-on recipe that feeds a Field Guide; refresh at most |
| Remove | 34 | 47% | No migration value |
| Repurpose | 1 | 1% | Homepage becomes the freeze page |

37 source pages collapse into **35 Field Guides**: `gitops.md` splits into four guides, while five pages merge into a guide that already has a source page (`configuration`, the two OCI pages, the two Triton pages, and the two serving pages `enable-function-calling` + `kserve-timeout`).

Dominant staleness driver is the UI, not the product: more than a third of the keepers walk through the RHOAI 2.x dashboard, whose navigation, image-import wizard, Container Size selector and serving-type screens have all changed in 3.x. YAML/CLI-first pages survive nearly untouched (`bucket-notifications`, `workbench-python-packages`, `high-availability`, `llm-auth-with-keycloak`, `kueue-preemption`).

Three product facts cut across many verdicts:

- **ModelMesh and KServe Serverless are retired in RHOAI 3.x.** "Starting with OpenShift AI 2.19, the multi-model serving platform based on ModelMesh is deprecated"; "If you are upgrading to Red Hat OpenShift AI 3.0, all workloads that use the retired Serverless or ModelMesh modes must be migrated before upgrading."
- **FMS Guardrails Orchestrator is deprecated in 3.5**; NeMo Guardrails is the single recommended framework.
- **Accelerator Profiles, the Container Size selector, and `OdhDashboardConfig.groupsConfig`** were replaced by Hardware Profiles (3.0) and the `Auth` resource (2.17).

## A. Remove (34 pages + 1 orphan file)

Already no migration value.

| Page | Why it goes | Cleanup it forces |
|---|---|---|
| `docs/index.md.bck` | Dead backup of the pre-template homepage; not built, not linked | Delete file |
| `getting-started/why-this-site.md` | Two paragraphs of why-we-exist marketing | `home.html` "Get started" button points here |
| `getting-started/openshift.md` | Vendor marketing + YouTube embed; no commands | Remove nav entry |
| `getting-started/opendatahub.md` | 6-line blurb listing ModelMesh as a core ODH component | `opendatahub.io` is the authoritative source |
| `getting-started/openshift-ai.md` | Four external links + pre-2024 dashboard screenshot | Replace with a link to Red Hat docs |
| `predictive-ai/what-is-predictive-ai.md` | Four bullets defining predictive AI; section-header page only | Collapses the Predictive AI section |
| `generative-ai/what-is-generative-ai.md` | Five mirrored bullets | Same |
| `odh-rhoai/gpu-pruner.md` | Third-party `wseaton/gpu-pruner` description; no install, command or YAML | Covered by Kueue + built-in idle culling |
| `odh-rhoai/from-zero-to-workbench/using-cli.md` | One paragraph pointing to a repo built on "OpenShift v4.14 and OpenShift AI 2.7" | Whole sub-section goes |
| `odh-rhoai/from-zero-to-workbench/using-ui.md` | Same link-out, same dead version pair | Same |
| `odh-rhoai/from-zero-to-workbench/using-developer-hub.md` | Three sentences to an "Experimental only. No support." template | Same |
| `demos/retail-object-detection.md` | 8 lines + a bundled ODSC East **2022** deck | Drop the PDF asset too |
| `demos/smart-city.md` | Video tour of a 2021 `jumpstart-library` demo | — |
| `demos/xray-pipeline.md` | Same, sibling 2021 demo; upstream pattern archived | — |
| `tools-and-applications/airflow.md` | Link-only; install repo last pushed 2023-02, OpenShift 4.12 | Pipeline guide must own its Airflow install |
| `tools-and-applications/apache-nifi.md` | Link farm; repo last pushed 2023-07 | — |
| `tools-and-applications/apache-spark.md` | Upstream feature prose + one repo link | — |
| `patterns/kafka/kafka-to-object-storage.md` | Secor unmaintained; manifests assume ZooKeeper, removed in Kafka 4.0 | Delete `secor.yaml`/`zookeeper-entrance.yaml` |
| `odh-rhoai/model-serving-type-modification.md` | Documents a workflow its own text says is unneeded since 2.16; ModelMesh half retired | Serving-type switching is a 2.16+ button |

Removed because of the decisions above:

| Page | Reason |
|---|---|
| `whats-new/whats-new.md` | Changelog for the old corpus; ~30 links would dangle. Each guide gets a "last verified" line instead |
| `odh-rhoai/rhoaibu-cluster-gitops.md` | Tour of an internal "no SLA, not for production" repo; zero in-page steps |
| `odh-rhoai/llm-guardrails.md` | Concept only; FMS deprecated, no NeMo owner |
| `odh-rhoai/stable_diffusion_safety_checker.md` | Legacy SD-1.5 checker, no runnable steps |
| `odh-rhoai/trustyai-guardrails-https-auth-guide.md` | Precise recipe for a component deprecated in 3.5; don't migrate |
| `generative-ai/llm-serving.md` | Glossary is reusable, but recommends removed runtimes (Caikit/TGIS) and 2023 models |
| `generative-ai/building-an-image-generation-app.md` | PoC tour; guardrail lessons harvested only if a guardrails guide is commissioned |
| `generative-ai/ai-for-everyone.md` | Parasol/MaaS PoC tour, competing with RHOAI's shipping MaaS direction |
| `demos/financial-fraud-detection.md` | 3-line pointer to a live workshop |
| `demos/llama2-finetune.md` | Pointer to a 2023 Ray+DeepSpeed Llama-2 example |
| `demos/llama3-finetune-kfto.md` | Pointer to an example on Kubeflow Training Operator v1, deprecated since 2.25 |
| `demos/stable-diffusion.md` | Pointer to an external DreamBooth example |
| `demos/water-pump-failure-prediction.md` | Bare pointer to an external edge-anomaly workshop |
| `demos/modelops-benchmarking.md` | 90% external `.adoc`; LM-Eval deprecated in 3.5 in favour of EvalHub |
| `tools-and-applications/mlflow.md` | Manual Helm install superseded by the product integration, as its own banner says |
| `patterns/starproxy.md` | Concept only, no deployment, maintenance unknown |

Dead weight outside the Markdown: the two demo decks/PDFs under `demos/retail-object-detection/` and `demos/xray-pipeline/`, and `docs/img` assets used only by removed pages.

## B. Migrate (37 pages → 35 Field Guides)

Effort: S ≤ 1 day, M 1–3 days, L > 3 days, for a writer who knows the product and can reach a 3.x cluster. "Ready" means it moves with only a product-version check.

### Collection 1 — Platform administration (19 guides)

| Proposed guide | Source | Refresh needed | Effort |
|---|---|---|---|
| Install and configure RHOAI with GitOps | `odh-rhoai/gitops.md` (§ Subscription/DSCI/DSC) | Drop `codeflare`, TGIS/`templateOrder`, `serviceMesh`; move group config to `Auth` | L |
| Administer the dashboard as code | `odh-rhoai/gitops.md` (§ dashboard config), `odh-rhoai/configuration.md` | Merge; replace `groupsConfig` with `Auth`; drop deprecated toggles; new screenshots | M |
| Projects, workbenches and connections as code | `odh-rhoai/gitops.md` (§ end-user objects) | Re-verify namespace labels and connection annotations (`connection-type-protocol` since 3.0) | M |
| Model serving as code | `odh-rhoai/gitops.md` (§ serving/auth), `odh-rhoai/enable-function-calling.md`, `odh-rhoai/kserve-timeout.md` | KServe RawDeployment only; refresh vLLM image and tool-parser flags; fix two scheme-less `quay.io` links; turn the Knative timeout into a RawDeployment troubleshooting section | M |
| Manage OpenShift groups for RHOAI | `odh-rhoai/openshift-group-management.md` | RBAC recipe is sound; verify against `Auth`; new screenshot; fix RHODS 1.x link | S |
| Pre-pull workbench and model images | `odh-rhoai/image-puller.md` | Re-pin images; remove "blog post" framing | S |
| Kueue preemption and quotas | `odh-rhoai/kueue-preemption/readme.md` | Add destructive-warning (setup deletes all ClusterQueues); fix typos | S |
| GPU enablement, time-slicing and MIG | `odh-rhoai/nvidia-gpus.md` | Refresh RHODS 1.x link, vLLM ≥2.10 claim, retired Falcon 180B, MPS caveat; consider splitting vGPU/MIG | L |
| Hardware Profiles | `odh-rhoai/accelerator-profiles.md` | Rewrite: AcceleratorProfile CRD deprecated in 3.0; taints/tolerations flow carries over | M |
| Build a custom workbench image | `odh-rhoai/custom-notebooks.md` | UBI9 only; Python 3.12 paths; remove RStudio (images removed in 3.5); new nav | M |
| Import and run AnythingLLM as a workbench | `odh-rhoai/custom-workbench-anythingllm.md` | 3.x import path, wizard labels, Hardware Profile; all 9 screenshots | M |
| Python packages in workbenches | `odh-rhoai/workbench-python-packages.md` | None | Ready |
| Connect local VS Code to a workbench kernel | `odh-rhoai/connect-vscode-to-rhoai-wb.md` | Kernel version, port notes, 11 screenshots | S |
| Secrets with External Secrets Operator | `odh-rhoai/secret-management.md` | Restructure from "our story" to imperative steps; verify `v1beta1` API | M |
| Deploy models from OCI registries, connected and air-gapped | `odh-rhoai/deploy-models-from-public-oci.md`, `odh-rhoai/deploy-validated-models-on-disconnected.md` | Merge; update wizard labels; re-pin 2.20 vLLM and ModelCar tags | M |
| Autoscale LLM serving with KEDA | `odh-rhoai/keda-autoscaling.md` | Technology Preview → GA; use the shipped KEDA operator | S |
| Serving metrics with user workload monitoring | `odh-rhoai/kserve-uwm-dashboard-metrics.md` | Version pins; verify dashboards against 3.x metrics | S |
| Reuse the ingress certificate for model serving | `odh-rhoai/single-stack-serving-certificate.md` | Re-verify DSC fields; rename "single stack" → "single-model serving" | S |
| ODH tools companion: import and use | `odh-rhoai/odh-tools-and-extensions-companion.md` | Promote the screenshot tour into a recipe (import image → run → use); current UI | S |

### Collection 2 — Generative AI serving (7 guides)

| Proposed guide | Source | Refresh needed | Effort |
|---|---|---|---|
| Distributed serving with llm-d and flow control | `generative-ai/llm-d.md` | Turn the "Quick Installation" pointer into inline steps | S |
| Authenticate model endpoints with Keycloak | `generative-ai/llm-auth-with-keycloak.md` | Fix role mismatch: realm/CEL use `auth-to-model`, JWT excerpt shows `auth-to-role` | Ready |
| High availability for model serving | `generative-ai/high-availability.md` | Fix `PDR`/`minAvailability` typos; otherwise current | Ready |
| RAG chatbot with vLLM and Milvus | `demos/llm-chat-doc/llm-chat-doc.md` | New model + embeddings; modern LangChain API; remove `<videos>` tail | M |
| From Podman AI Lab to enterprise RAG | `demos/podman-ai-lab-to-rhoai/podman-ai-lab-to-rhoai.md` | TheBloke repo gone; 2.16/4.18 pins; personal quay images; Service Mesh/cert section | L |
| Code assistant in Code Server | `demos/codellama-continue/codellama-continue.md` | Continue config is YAML now; pinned VSIX 0.9.91; CodeLlama era | M |
| Credit-card fraud: train, track, serve, consume | `demos/credit-card-fraud-detection-mlflow/credit-card-fraud.md` | Rebuild serving on KServe RawDeployment; note `tf2onnx` removal in 3.5; screenshots | L |

### Collection 3 — Data, tools and pipelines (9 guides)

| Proposed guide | Source | Refresh needed | Effort |
|---|---|---|---|
| MinIO for prototyping | `tools-and-applications/minio/minio.md` | Pin an image; community console lost admin/bucket management in RELEASE.2025-05-24 — redo bucket step with `mc` | S |
| Rclone web UI on OpenShift | `tools-and-applications/rclone/rclone.md` | Source image last pushed 2023-02; current dashboard wording; fix `![Spark]` alt | S |
| NVIDIA Riva on OpenShift | `tools-and-applications/riva/riva.md` | Riva 2.11 chart and GPU matrix are old | M |
| Triton ensemble serving | `tools-and-applications/ensemble-serving/ensemble-serving.md`, `odh-rhoai/custom-runtime-triton.md` | Merge the two walkthroughs; KServe only; current screenshots and Triton doc link | M |
| Ceph bucket notifications | `patterns/bucket-notifications/bucket-notifications.md` | None | Ready |
| Airflow and Elyra pipeline | `demos/telecom-customer-churn-airflow/telecom-customer-churn-airflow.md` | Own the Airflow install; refresh `quay.io/eformat/*` pins; screenshots | M |
| Train and serve YOLOv5 | `demos/yolov5-training-serving/yolov5-training-serving.md` | Rebuild serving on KServe (ModelMesh + OVMS plugin deprecated); `/dev/shm` link | L |
| Submit a KFP pipeline from Tekton | `tools-and-applications/datasciencepipeline/datasciencepipeline.md` | Verify the pattern on 3.x; refresh model-registry references | M |
| Kafka to Knative serving | `patterns/kafka/kafka-to-serverless/kafka-to-serverless.md` | Verify KnativeKafka/Eventing support on current Serverless before committing | M |

### Gaps to author fresh (not migrated)

These are the pages a Field Guides set needs and this site never had, or lost:

- **Zero to workbench on RHOAI 3.x** — the three `from-zero-to-workbench` links pointed at a 2.7-era repo. One honest guide covering UI and CLI is the highest-value new page.
- **Use the integrated MLflow** — replaces `tools-and-applications/mlflow.md`'s manual Helm install.
- **Evaluation with EvalHub** — replaces the LM-Eval path in `modelops-benchmarking`.
- **Guardrails with NeMo** — only when an owner exists.

## C. Resolved questions (formerly the decide bucket)

| Page | Question that was open | Outcome |
|---|---|---|
| `index.md` + `theme_override/home.html` | Marketing hero or plain index? | Repurpose: plain guide index + freeze banner; delete custom template |
| `whats-new.md` | Restart or drop? | Drop; per-guide "last verified" |
| `rhoaibu-cluster-gitops.md` | Pointer to internal repo? | Drop; link the repo once from the GitOps guide |
| `accelerator-profiles.md` | Deprecated mechanism in scope? | Migrate as Hardware Profiles |
| `custom-runtime-triton.md` | Retired ModelMesh | Merge into the KServe Triton guide |
| `kserve-timeout.md` | Knative-only fix | Fold into model-serving-as-code as RawDeployment troubleshooting |
| Guardrails trio + SD checker | Deprecated framework | Drop; NeMo guide deferred |
| `odh-tools-and-extensions-companion.md` | Tour vs recipe | Promote to a recipe |
| `llm-serving.md` | Glossary vs runtime survey | Drop page; reuse the glossary as an intro in the new repo |
| `building-an-image-generation-app.md` | PoC tour | Drop; harvest guardrail lessons only if commissioned |
| `ai-for-everyone.md` | PoC tour | Archive |
| Six external-pointer demos | Adopt, index or drop? | Drop; link the external source |
| `mlflow.md` | Manual install vs product | Drop manual path |
| `datasciencepipeline.md` | 2.15 Tech Preview | Verify then migrate |
| `kafka-to-serverless.md` | Knative support unclear | Verify then migrate |
| `starproxy.md` | No procedure | Drop |

## D. Cross-cutting rules for the new guides

1. **YAML/CLI first.** Every UI walkthrough in this corpus is a 2.x artefact; every YAML recipe survived 3.x. Screenshots are optional and dated.
2. **Guide header:** baseline (RHOAI 3.5, OpenShift 4.19+), last-verified date, prerequisites, teardown. This replaces `whats-new` and gives the staleness signal the site lacks.
3. **No personal or internal images.** Replace `quay.io/<person>/…`, `quay.io/eformat/…`, and internal-repo assumptions, or label them unsupported. Pin digests, never `:latest`.
4. **One serving story:** KServe RawDeployment only. No multi-model serving, no serving-type switching, no Serverless annotations.
5. **Every command shows expected output**; every destructive command carries a warning (Kueue's setup target is the current offender).
6. **CI:** `mkdocs build --strict`, link check, and a grep for stale markers (`RHODS`, `2.1x`, `modelmesh`, `localhost`).

## E. Migration plan

### Phase 0 — This branch (done)

Review, decisions, plan. `CONTENT-REVIEW.md` only.

### Phase 1 — Freeze this repo (after go-ahead)

1. Delete the 34 remove-bucket pages and their orphan assets.
2. Delete `theme_override/home.html`; make `index.md` a plain guide index with the freeze banner.
3. Remove `whats-new`; fix the nav duplicates (`gitops.md`, `secret-management.md`) and the three broken links (`enable-function-calling.md` ×2 scheme-less `quay.io`, `deploy-validated-models-on-disconnected.md` regex residue).
4. Add `redirects` (mkdocs-redirects or host-level) from every removed URL to its guide or external source.
5. Keep the 37 migrate pages live but marked "being replaced by <guide>" — do not delete a page before its guide ships.

### Phase 2 — Author the Field Guides, in waves

| Wave | Contents | Why this order | Guides |
|---|---|---|---:|
| 1 | Ready pages + YAML/CLI recipes | No cluster UI dependency; near-zero refresh | 8 |
| 2 | Admin-as-code and serving recipes | High value, YAML-driven, medium refresh | 11 |
| 3 | UI-heavy guides | New 3.x screenshots required; needs a cluster and a screenshot pass | 11 |
| 4 | Long-form demos | Rewrite of a section each (serving, model, storage) | 5 |

Wave 1 (8): bucket notifications, Python packages, Keycloak auth, high availability, Kueue, image pre-pull, group management, ODH tools.
Wave 2 (11): the four GitOps guides, Hardware Profiles, secrets/ESO, OCI + air-gapped, KEDA, serving metrics, ingress certificate, llm-d.
Wave 3 (11): GPU enablement, custom workbench image, AnythingLLM, VS Code kernel, MinIO, Rclone, Riva, Triton ensemble, Airflow/Elyra, Tekton→KFP, Kafka→Knative.
Wave 4 (5): Podman→RHOAI, credit-card fraud, YOLOv5, RAG chatbot, code assistant.

### Phase 3 — Retire old pages

For each guide: verify it on the baseline, then remove its source page and redirect. A old page is never removed while its replacement is unverified. Track this in the redirect map, not in a changelog page.

### Phase 4 — Deferred work

- NeMo Guardrails guide (owner needed).
- Kubeflow Trainer v2 fine-tuning guide (replaces the Llama/KFTO pointers).
- EvalHub evaluation guide (replaces LM-Eval).
- A refreshed zero-to-workbench guide.

## F. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Screenshot refresh is the largest cost (11 guides in wave 3) | Schedule slip; guides ship stale | YAML/CLI-first; ship UI guides last; one screenshot pass on one cluster |
| External dependencies rot (TheBloke, Secor, eformat images, personal quay repos) | Guides break silently | Pin digests; no personal registries; link check in CI |
| Two-repo period duplicates maintenance | Effort split, divergence | Freeze the old site immediately; banner + redirects |
| No owner for guardrails / image-gen / MaaS | Those topics disappear | Explicitly deferred, not silently dropped |
| RHOAI 3.x itself moves (LM-Eval → EvalHub, KFTO v2, FMS removal) | New guides stale on arrival | Baseline header + "last verified"; review deferred items each release |
| Removal breaks inbound links | 404s from blogs/SEO | Redirect map covers all 34 removed URLs |

## G. Suggestions worth considering beyond the migration

- **Cut the site to a searchable index of guides** rather than a taxonomy (no more "Predictive AI" / "Generative AI" section pages). The taxonomy is what produced the two definitional stubs.
- **Keep a public "what we retired and why" page** in the new repo. It costs one page and prevents the same stale demo stubs from reappearing.
- **Adopt a "verified on" badge per guide** (product + date). The absence of this is why a 2023 page and a 2026 page look identical today.
- **Archive rather than delete the PoC write-ups** (`ai-for-everyone`, `building-an-image-generation-app`) in the new repo or in a repo README; they carry lessons the guides will want to cite.
