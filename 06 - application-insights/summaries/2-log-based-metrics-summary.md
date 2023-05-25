# Summary

The original content discusses metrics and logging in the context of Application Insights. It explains that there are two types of metrics: log-based metrics and pre-aggregated metrics. Log-based metrics are translated into Kusto queries from stored events and provide more dimensions for data analysis and diagnostics. On the other hand, pre-aggregated metrics are stored as pre-aggregated time series and offer better performance at query time.

The content emphasizes the benefits of retaining a complete set of events through logs, which can greatly improve visibility into application health and usage. It mentions that using logs allows for analyzing specific events, such as counting requests to a particular URL or diagnosing issues with an app. However, it also acknowledges that collecting a complete set of events may not be practical for high-volume applications, and techniques like sampling and filtering are implemented to reduce telemetry volume.

The content further discusses SDKs, mentioning that developers can manually send events using the SDK or rely on automatic collection through auto-instrumentation. It highlights that newer SDKs implement pre-aggregation of metrics during collection, resulting in better accuracy and reduced data ingestion.

Finally, it notes that the collection endpoint pre-aggregates events before ingestion sampling, ensuring that ingestion sampling does not impact the accuracy of pre-aggregated metrics.

Overall, the content emphasizes the importance of metrics and logs in understanding application health, usage, and performance, while highlighting the trade-offs and techniques involved in collecting and analyzing event data.

# Dictionary of Terms


**Application Insights**

Summary: Application Insights is a service offered by Microsoft Azure that provides application performance monitoring and diagnostics. It allows developers to monitor the health, usage, and performance of their applications by collecting and analyzing telemetry data.

Usage: Application Insights is used to gain insights into the behavior and performance of applications, track application dependencies, detect and diagnose issues, and monitor application availability. It provides features like real-time metrics, dashboards, alerts, and the ability to drill down into specific events and traces.

Official Website: [Application Insights](https://azure.microsoft.com/en-us/services/application-insights/)

YouTube Introduction: [Introduction to Azure Application Insights](https://www.youtube.com/watch?v=kmE6k7CG1JM)

---

**Azure Portal**

Summary: Azure Portal is the web-based user interface provided by Microsoft Azure for managing and monitoring Azure resources. It serves as a central hub for managing various Azure services and resources in a unified manner.

Usage: Azure Portal is used to create, configure, and monitor Azure resources such as virtual machines, databases, storage accounts, and more. It provides a graphical interface for managing resources, setting up monitoring and alerts, accessing logs and diagnostics, and performing various administrative tasks.

Official Website: [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/)

YouTube Introduction: [Azure Portal Introduction](https://www.youtube.com/watch?v=Xjre8L7GvKI)

---

**Kusto Queries**

Summary: Kusto (Azure Data Explorer) is a service and query language provided by Microsoft Azure for analyzing large volumes of data. Kusto queries are used to retrieve, transform, and analyze data stored in various data sources, including log-based metrics in the context of Application Insights.

Usage: Kusto queries are used to perform complex data analysis tasks, including filtering, aggregating, and visualizing data. In the context of log-based metrics in Application Insights, Kusto queries are used to translate log-based metrics into actionable insights and perform ad-hoc diagnostics.

Official Website: [Azure Data Explorer](https://azure.microsoft.com/en-us/services/data-explorer/)

YouTube Introduction: [Getting Started with Azure Data Explorer](https://www.youtube.com/watch?v=Q6c-NY9bVtQ)

---

**SDK (Software Development Kit)**

Summary: An SDK, or Software Development Kit, is a collection of software tools, libraries, and documentation that developers use to create applications for a specific platform, framework, or service. SDKs provide pre-built components and APIs that simplify development tasks and enable integration with the target platform or service.

Usage: SDKs are used by developers to build applications that leverage the capabilities of a specific platform or service. They provide ready-to-use code snippets, APIs, and tools that abstract away complex implementation details, allowing developers to focus on writing application logic. SDKs are available for various programming languages and platforms, and they streamline the development process by providing a set of consistent and standardized tools and libraries.

Official Website: Varies based on the specific SDK

YouTube Introduction: Depends on the specific SDK

---

**Telemetry**

Summary: Telemetry refers to the process of collecting and transmitting data about the behavior, usage, and performance of a software application or system. It involves capturing and sending relevant data points, often in the form of events or metrics, to a central monitoring or analytics service for analysis and insights.

Usage: Telemetry is used to gain visibility into how an application or system is performing, how it is being used, and to identify potential issues or areas for improvement. It helps developers and system administrators monitor and diagnose problems, optimize performance

, and make informed decisions based on real-world usage patterns.

Official Website: N/A

YouTube Introduction: [Application Telemetry](https://www.youtube.com/watch?v=Zzj5gzeTcCA)
