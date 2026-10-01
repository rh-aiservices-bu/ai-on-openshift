# LLM Serving

!!! info
    All source files and examples used in this article are available in **[this repo](https://github.com/rh-aiservices-bu/llm-on-openshift){:target="_blank"}**!

**LLMs (Large Language Models)** are the subject of the day. And of course, you can definitely work with them on OpenShift with ODH or RHOAI, from creating a Chatbot, using them as simple APIs to summarize or translate texts, to deploying a full application that will allow you to quickly query your documentation or knowledge base in natural language.

You will find on this page instructions and examples on how to set up the different elements that are needed for those different use cases, as well as fully implemented and ready-to-use applications.

## Context and definitions

Many people are only beginning to discover those technologies. After all, it has been a little bit more than a year since the general public is aware of them, and many related technologies, tools or applications are only a few months, even weeks (and sometimes days!) old. So let's start with a few definitions of the different terms that will be used in this article.

- **LLM**: A Large Language Model (LLM) is a sophisticated artificial intelligence system designed for natural language processing. It leverages deep learning techniques to understand and generate human-like text. LLMs use vast datasets to learn language patterns, enabling tasks like text generation, translation, summarization, and more. These models are versatile and can be fine-tuned for specific applications, like chatbots or content creation. LLMs have wide-ranging potential in various industries, from customer support and content generation to research and education, but their use also raises concerns about ethics, bias, and data privacy, necessitating responsible deployment and ongoing research.
- **Fine-tuning**: Fine-tuning in the context of Large Language Models (LLMs) is a process of adapting a pre-trained, general-purpose model to perform specific tasks or cater to particular applications. It involves training the model on a narrower dataset related to the desired task, allowing it to specialize and improve performance. Fine-tuning customizes the LLM's capabilities for tasks like sentiment analysis, question answering, or chatbots. This process involves adjusting hyperparameters, data preprocessing, and possibly modifying the model architecture. Fine-tuning enables LLMs to be more effective and efficient in specific domains, extending their utility across various applications while preserving their initial language understanding capabilities.
- **RAG**: RAG, or Retrieval-Augmented Generation, is a framework in natural language processing. It combines two key components: retrieval and generation. Retrieval involves selecting relevant information from a vast knowledge base, like the internet, and generation pertains to creating human-like text. RAG models employ a retriever to fetch context and facts related to a specific query or topic and a generator, often a language model, to produce coherent responses. This approach enhances the quality and relevance of generated text, making it useful for tasks like question answering, content summarization, and information synthesis, offering a versatile solution for leveraging external knowledge in AI-powered language understanding and production.
- **Embeddings**: Embeddings refer to a technique in natural language processing and machine learning where words, phrases, or entities are represented as multi-dimensional vectors in a continuous vector space. These vectors capture semantic relationships and similarities between words based on their context and usage. Embeddings are created through unsupervised learning, often using models like Word2Vec or GloVe, which transform words into fixed-length numerical representations. These representations enable machines to better understand and process language, as similar words have closer vector representations, allowing algorithms to learn contextual associations. Embeddings are foundational in tasks like text classification, sentiment analysis, machine translation, and recommendation systems.
- **Vector Database**: A vector database is a type of database designed to efficiently store and manage vector data, which represents information as multidimensional arrays or vectors. Unlike traditional relational databases, which organize data in structured tables, vector databases excel at handling unstructured or semi-structured data. They are well-suited for applications in data science, machine learning, and spatial data analysis, as they enable efficient storage, retrieval, and manipulation of high-dimensional data points. Vector databases play a crucial role in various fields, such as recommendation systems, image processing, natural language processing, and geospatial analysis, by facilitating complex mathematical operations on vector data for insights and decision-making.
- **Quantization**: Model quantization is a technique in machine learning and deep learning aimed at reducing the computational and memory requirements of neural networks. It involves converting high-precision model parameters (usually 32-bit floating-point values) into lower precision formats (typically 8-bit integers or even binary values). This process helps in compressing the model, making it more lightweight and faster to execute on hardware with limited resources, such as edge devices or mobile phones. Quantization can result in some loss of model accuracy, but it's a trade-off that balances efficiency with performance, enabling the deployment of deep learning models in resource-constrained environments without significant sacrifices in functionality.

*Fun fact: all those definitions were generated by an LLM...*

!!! note "Do you want to know more?"
    Here are a few worth reading articles:

    - [Best article ever: A jargon-free explanation of how AI large language models work](https://arstechnica.com/science/2023/07/a-jargon-free-explanation-of-how-ai-large-language-models-work/){:target="_blank"}
    - [Understanding LLama2 and its architecture](https://medium.com/towards-generative-ai/understanding-llama-2-architecture-its-ginormous-impact-on-genai-e278cb81bd5c){:target="_blank"}
    - [RAG vs Fine-Tuning, which is best?](https://medium.com/towards-data-science/rag-vs-finetuning-which-is-the-best-tool-to-boost-your-llm-application-94654b1eaba7){:target="_blank"}

## LLM Serving

LLM Serving is not a trivial task, at least in a production environment...

![One does not simply serve an LLM](img/one-does-not.png){ width="500" }

- LLMs are usually huge (several GBs, tens of GBs...) and require GPU(s) with enough memory if you want decent accuracy and performance. Granted, you can run smaller models on home hardware with good results, but that's not the subject here. After all we are on OpenShift, so more in a large organization environment than in an enthusiastic programmer basement!
- A served LLM will generally be used by multiple applications and users simultaneously. Since you can't just throw resources at it and scale your infrastructure easily because of the previous point, you want to optimize response time by for example batching queries, caching or buffering them,... Those are special operations that have to be handled specifically.
- When you load an LLM, there are parameters you want to tweak at load time, so a "generic" model loader is not the best suited solution.

### LLM Serving solutions

Fortunately, we have different solutions to handle LLM Serving.

On **[this repo](https://github.com/rh-aiservices-bu/llm-on-openshift){:target="_blank"}** you will find:

- **Recipes** to deploy different types of LLM Servers, either using the **Single Stack Model Serving** available in ODH and RHOAI, or as **Standalone deployments**.
- **Notebook examples** on how to query those different servers are available.

#### Serving Runtimes for Single Stack Model Serving

On top of the Caikit+TGIS or TGIS built-in runtimes, the following custom runtimes can be imported in the Single-Model Serving stack of Open Data Hub or OpenShift AI.

- [vLLM Serving Runtime](https://github.com/rh-aiservices-bu/llm-on-openshift/blob/main/serving-runtimes/vllm_runtime/README.md){:target="_blank"}
- [Hugging Face Text Generation Inference](https://github.com/rh-aiservices-bu/llm-on-openshift/blob/main/serving-runtimes/hf_tgi_runtime/README.md){:target="_blank"}

#### Standalone Inference Servers

- vLLM: how to deploy vLLM, the "Easy, fast, and cheap LLM serving for everyone".
    - on [GPU](https://github.com/rh-aiservices-bu/llm-on-openshift/blob/main/llm-servers/vllm/gpu/README.md){:target="_blank"}: 
    - on [CPU](https://github.com/rh-aiservices-bu/llm-on-openshift/blob/main/llm-servers/vllm/cpu/README.md){:target="_blank"}:
- [Hugging Face TGI](https://github.com/rh-aiservices-bu/llm-on-openshift/blob/main/llm-servers/hf_tgi/README.md){:target="_blank"}: how to deploy the Text Generation Inference server from Hugging Face.
- [Caikit-TGIS-Serving](https://github.com/opendatahub-io/caikit-tgis-serving){:target="_blank"}: how to deploy the Caikit-TGIS-Serving stack, from OpenDataHub.

### What are the differences?

You should read the documentation of those different model servers, as they present different characteristics:

- Different acceleration features can be implemented from one solution to the other. Depending on the model you choose, some features may be required.
- The endpoints can be accessed in REST or gRPC mode, or both, depending on the server.
- APIs are different, with some solutions offering an OpenAI compatible, which simplifies the integration with some libraries like Langchain.

### Which model to use?

In this section we will assume that you want to work with a "local" open source model, and not consume a commercial one through an API, like OpenAI's ChatGPT or Anthropic's Claude.

There are literally hundreds of thousands of models available, almost all of them available on the [Hugging Face](https://huggingface.co/) site. If you don't know what this site is, you can think of it as what Quay or DockerHub are for containers: a big repository of models and datasets ready to download and use. Of course Hugging Face (the company) is also creating code, providing hosting capabilities,... but that's another story.

So which model to choose will depend on several factors:

- Of course how good this model is. There are several benchmarks that have been published, as well as constantly updated rankings.
- The dataset it was trained on. Was it curated or just raw data from anywhere, does it contain nsfw material,...? And of course what the license is (some datasets are provided for research only or non-commercial).
- The license of the model itself. Some are fully open source, some claim to be... They may be free to use in most cases, but have some restrictions attached to them (looking at you Llama2...).
- The size of the model. Unfortunately that may be the most restrictive point for your choice. The model simply must fit on the hardware you have at your disposal, or the amount of money you are willing to pay.

Currently, a good **LLM** with interesting performance for a relatively small size is **[Mistral-7B](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2){:target="_blank"}**. Fully Open Source with an Apache 2.0 license, it will fit in an unquantized version on about 22GB of VRAM, which is perfect for an A10G card.

**Embeddings** are another type of model often associated with LLMs as they are used to convert documents into vectors. A database of those vectors can then be queried to find the documents related to a query you make. This is very useful for the RAG solution we are going to talk about later on. NomicAI recently released a really performant and fully open source embeddings model, **[nomic-embed-text-v1](https://huggingface.co/nomic-ai/nomic-embed-text-v1){:target="_blank"}**

## LLM Consumption

Once served, consuming an LLM is pretty straightforward, as at the end of the day it's *only* an API call.

You can always query those models directly through a curl command or a simple request using Python. However, for easier consumption and integration with other tools, a few libraries/SDKs are available to streamline the process. They will allow you to easily connect to Vector Databases or Search Agents, chain multiple models, tweak parameters,... in a few lines of code. The main libraries at the time of this writing are [Langchain](https://www.langchain.com/){:target="_blank"}, [LlamaIndex](https://www.llamaindex.ai/){:target="_blank"} and [Haystack](https://haystack.deepset.ai/){:target="_blank"}.

In the **[LLM on OpenShift examples section](https://github.com/rh-aiservices-bu/llm-on-openshift/tree/main/examples){:target="_blank"}** repo, you will find several notebooks and full UI examples that will show you how to use those libraries with different types of model servers to create your own **Chatbot**!
