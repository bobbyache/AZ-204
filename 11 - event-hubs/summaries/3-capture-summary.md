# Summary

The original content discusses Azure Event Hubs and its capabilities for capturing and processing streaming data.

Azure Event Hubs enables the automatic capture of streaming data in Event Hubs and provides flexibility in specifying a time or size interval for capturing. This process is fast, incurs no administrative costs, and scales automatically based on the Event Hubs throughput units.

Event Hubs Capture allows real-time and batch-based pipelines to be processed on the same stream, enabling solutions that can grow over time. Event Hubs functions as a time-retention durable buffer for telemetry ingress, working similarly to a distributed log. The scalability of Event Hubs relies on the partitioned consumer model, where each partition is an independent segment of data consumed separately. Data in Event Hubs ages off based on a configurable retention period, ensuring that an event hub never becomes overly full.

Captured data is written in the Apache Avro format, which is a compact and fast binary format with rich data structures. Event Hubs Capture provides the flexibility to specify Azure Blob storage or Azure Data Lake Storage accounts for storing the captured data. These accounts can be located in the same region as the event hub or in different regions, enhancing flexibility.

Event Hubs Capture allows setting up a capture window with a "first wins policy" to control capturing. Each partition captures independently and writes a completed block blob at the time of capture, following a specific storage naming convention. Throughput units control the traffic in Event Hubs, with each unit allowing a certain amount of ingress and egress. Standard Event Hubs can be configured with 1-20 throughput units.

Once configured, Event Hubs Capture runs automatically upon the arrival of the first event and continues running. To provide a marker for downstream processing, Event Hubs writes empty files during periods of no data. This predictable cadence and marker assist in feeding batch processors.

Overall, Azure Event Hubs and Event Hubs Capture offer powerful capabilities for capturing, storing, and processing streaming data in a scalable and flexible manner.

![Image](https://learn.microsoft.com/en-us/training/wwl-azure/azure-event-hubs/media/event-hubs-capture.png)

# Term Dictionary


### Apache Avro

Apache Avro is a compact, fast, and binary data serialization format used for storing captured data in Azure Event Hubs. Avro provides rich data structures with inline schema, making it widely used in various data processing systems such as the Hadoop ecosystem, Stream Analytics, and Azure Data Factory. [Official Website](https://avro.apache.org/)

### Azure Blob storage

Azure Blob storage is a scalable and cost-effective storage solution provided by Microsoft Azure. It is used in Azure Event Hubs for storing the captured data. Blob storage enables the storage and retrieval of large amounts of unstructured object data, such as text, binary, or media files. [Official Website](https://azure.microsoft.com/services/storage/blobs/)

### Azure Data Lake Storage

Azure Data Lake Storage is a scalable and secure data lake solution offered by Microsoft Azure. It is an option for storing the captured data in Azure Event Hubs. Data Lake Storage provides a unified storage platform capable of handling big data analytics workloads and integrating with various data processing frameworks. [Official Website](https://azure.microsoft.com/services/storage/data-lake-storage/)

### Azure Event Hubs

Azure Event Hubs is a highly scalable and real-time data streaming platform provided by Microsoft Azure. It enables the capture, storage, and processing of large amounts of event data from various sources and devices. Event Hubs uses a partitioned consumer model and allows for automatic scaling based on throughput units. It is commonly used in scenarios such as telemetry ingress, IoT data ingestion, and real-time analytics. [Official Website](https://azure.microsoft.com/services/event-hubs/)

### Event Hubs Capture

Event Hubs Capture is a feature of Azure Event Hubs that facilitates the automatic capturing of streaming data and storing it in Azure Blob storage or Azure Data Lake Storage. It allows real-time and batch-based pipelines to process the captured data from the same stream. Event Hubs Capture provides flexibility in specifying storage accounts, capture windowing, and retention policies. It helps in building scalable and reliable data processing solutions. [Official Documentation](https://docs.microsoft.com/azure/event-hubs/event-hubs-capture-overview)

### Hadoop ecosystem

The Hadoop ecosystem refers to the collection of open-source software frameworks and tools that are built around the Apache Hadoop platform. Hadoop provides a distributed storage and processing framework for big data applications. The ecosystem includes various components such as Hadoop Distributed File System (HDFS), MapReduce, Hive, Pig, and more. These tools and frameworks enable scalable and parallel processing of large datasets. [YouTube Overview](https://www.youtube.com/watch?v=HZqDGnPmj7M)

### Stream Analytics

Azure Stream Analytics is a real-time analytics service provided by Microsoft Azure. It allows you to process and analyze streaming data from various sources in real-time, including Azure Event Hubs. Stream Analytics supports SQL-like query language for real-time data transformations and provides integration with other Azure services for building end-to-end streaming solutions. [Official Website](https://azure.microsoft.com/services/stream-analytics/)

### Azure Data Factory

Azure Data Factory is a cloud-based data integration service provided by Microsoft Azure. It allows you to orchestrate and automate the movement and transformation of data across various sources and destinations. Azure Data Factory supports hybrid data integration scenarios, enabling data movement between on-premises and cloud environments. It provides a visual interface for designing data pipelines, scheduling data workflows, and monitoring data integration processes. [Official Website](https://azure.microsoft.com/services/data-factory/)

### Distributed log

A distributed log is a concept that refers to a scalable and fault-tolerant mechanism for recording and storing events or data entries across multiple nodes in a distributed system. In the context of Azure Event Hubs, Event Hubs acts as a time-retention durable buffer for telemetry ingress, functioning similar to a distributed log. Each partition in Event Hubs represents an independent segment of data that is consumed and aged off based on configurable retention policies. [YouTube Overview](https://www.youtube.com/watch?v=t0G8RMF1zZo)

### Partitioned consumer model

The partitioned consumer model is a fundamental concept in Azure Event Hubs for achieving scalability and parallel processing of data. In Event Hubs, data is divided into partitions, and each partition is an independent segment of data. Consumers can read and process data from these partitions independently, allowing for high throughput and efficient data processing. The partitioned consumer model ensures that the data stream can be effectively distributed across multiple consumers. [Official Documentation](https://docs.microsoft.com/azure/event-hubs/event-hubs-features#event-hubs-partitions)

### Spark

Apache Spark is an open-source distributed data processing framework that provides fast and general-purpose big data processing capabilities. It offers in-memory computing, fault tolerance, and support for various data processing tasks such as batch processing, real-time streaming, machine learning, and graph processing. Spark can be integrated with Azure Event Hubs to perform data processing and analytics on the captured streaming data. [Official Website](https://spark.apache.org/)

### Storage naming convention

The storage naming convention refers to the structure and format used for naming and organizing files in storage systems. In the context of Event Hubs Capture in Azure, the captured data is stored in Azure Blob storage or Azure Data Lake Storage using a specific naming convention. The convention includes elements such as the namespace, event hub, partition ID, year, month, day, hour, minute, and second, forming a hierarchical structure that helps in organizing and retrieving the captured data efficiently. [Official Documentation](https://docs.microsoft.com/azure/event-hubs/event-hubs-capture-overview#storage-naming-convention)

### Throughput units

Throughput units are a measure of capacity in Azure Event Hubs, used to control the traffic flowing through the event hub. Each throughput unit allows a specific amount of ingress (data sent to the event hub) and egress (data read from the event hub) operations per unit of time. The number of throughput units determines the overall throughput capacity and can be scaled up or down based on the workload requirements.

In the standard tier of Event Hubs, a single throughput unit provides the capacity for 1 MB per second or 1000 events per second of ingress and twice that amount for egress. You can configure standard Event Hubs with 1 to 20 throughput units. If you require higher throughput, you can request a quota increase for additional throughput units.

Throughput units are essential for managing the rate at which data can be ingested into and read from an event hub. They help control the flow of data and prevent throttling when the incoming or outgoing data exceeds the capacity of the allocated throughput units. By adjusting the number of throughput units, you can scale the capacity of Event Hubs to handle varying workloads effectively.

[Official Documentation](https://docs.microsoft.com/azure/event-hubs/event-hubs-purchasing-considerations#throughput-units)