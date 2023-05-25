# Summary

The original content explains how to enable Application Insights, a monitoring and diagnostics service provided by Microsoft. It describes two methods of enabling Application Insights: Auto-Instrumentation (agent) and adding the Application Insights SDK to the application code. Auto-instrumentation is preferred as it requires no developer investment and eliminates future SDK update overhead. The content highlights that auto-instrumentation is the only option when source code access is unavailable. It also mentions that the list of services supported by auto-instrumentation changes rapidly and provides a link to the up-to-date list. Installing the Application Insights SDK is necessary when custom events, telemetry control, or auto-instrumentation limitations arise. The SDK requires instrumenting the web app, background components, and JavaScript. The telemetry data is directed to an Application Insights resource using a unique token. The SDK supports distributed tracing for various technologies, and manual tracking is possible through the TrackDependency method. Additionally, the content mentions OpenCensus, an open-source library distribution that facilitates metrics collection and distributed tracing with popular technologies like Redis, Memcached, and MongoDB.

# Terms Dictionary


### Application Insights

**Summary**: Application Insights is a monitoring and diagnostics service provided by Microsoft. It helps developers monitor the performance and availability of their applications, detect issues, and gain insights into user behavior.

**Usage**: Application Insights can be enabled through auto-instrumentation or by adding the Application Insights SDK to the application code. It provides features like telemetry collection, distributed tracing, and custom events and metrics. Developers can analyze the collected data to identify performance bottlenecks, troubleshoot issues, and optimize their applications.

**Official Website**: [Application Insights](https://azure.microsoft.com/en-us/services/application-insights/)

**YouTube Video**: [Introduction to Application Insights](https://www.youtube.com/watch?v=3GtO3TcIhzU)

---

### Auto-Instrumentation (agent)

**Summary**: Auto-Instrumentation is a method of enabling monitoring and telemetry collection in an application without requiring manual code changes. It typically involves using an agent or library that automatically instruments the application's code to collect relevant data.

**Usage**: Auto-Instrumentation is the preferred method for enabling Application Insights when source code access is limited or when developers want to avoid manual instrumentation. It eliminates the need for developers to modify their code and enables them to collect telemetry automatically. It is especially useful when instrumenting applications where the source code is not available, such as third-party libraries or external services.

**YouTube Video**: [Auto-Instrumentation Explained](https://www.youtube.com/watch?v=5tWLjC1gawI)

---

### OpenCensus

**Summary**: OpenCensus is an open-source distribution of libraries that provides metrics collection and distributed tracing capabilities for applications and services. It enables developers to collect telemetry data and trace requests across different components and services in a distributed system.

**Usage**: OpenCensus allows developers to instrument their applications and services to collect metrics and traces. It supports various programming languages and integrates with popular technologies like Redis, Memcached, and MongoDB. With OpenCensus, developers can gain insights into the performance and behavior of their distributed systems, troubleshoot issues, and optimize resource utilization.

**Official Website**: [OpenCensus](https://opencensus.io/)

**YouTube Video**: [Introduction to OpenCensus](https://www.youtube.com/watch?v=puzk79E6tBk)

---

### SDK (Software Development Kit)

**Summary**: A Software Development Kit (SDK) is a collection of tools, libraries, documentation, and samples that assist developers in building software applications for a specific platform or framework.

**Usage**: SDKs provide developers with pre-built components and resources that can be used to simplify development tasks and enable integration with specific platforms, frameworks, or services. In the context of Application Insights, the SDK allows developers to instrument their applications and collect telemetry data. It provides APIs and functionalities for custom events, metrics, distributed tracing, and more.

**YouTube Video**: [Introduction to Software Development Kits](https://www.youtube.com/watch?v=3sjv95pOJxY)

