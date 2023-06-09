# Landscape

- Client Libraries
- Basic Usage / Reason for being
- Security (support for authz and authn)
- Wire Protocols
- Availability and Throughput
- Pricing Tiers


# Event-driven architecture vs. Message-driven architecture

### Summary

Event-driven architecture focuses on reacting to events asynchronously, allowing systems to be highly responsive. Message-based architecture revolves around exchanging messages between components, ensuring reliable delivery. Event-driven is event-triggered, while message-based is message-centric. Both provide loose coupling and scalability but differ in communication patterns.

### Detail

An event-driven distributed cloud architecture and a message-based distributed cloud architecture are both approaches to building distributed systems in the cloud. While they share some similarities, there are key differences between them.

Event-driven Distributed Cloud Architecture:
In an event-driven architecture, systems communicate and react to events that occur within the system or from external sources. An event can be any significant occurrence or change of state that is of interest to the system. Events can be generated by various components, such as sensors, user interactions, or other services. The architecture typically consists of event producers, event consumers, and an event bus or broker that facilitates the communication between them.

Key characteristics of an event-driven distributed cloud architecture include:

1. Asynchronous Communication: Events are typically communicated asynchronously, decoupling the producers from the consumers. Producers publish events to the event bus, and consumers subscribe to specific event types they are interested in.

2. Loose Coupling: Event-driven systems are loosely coupled, meaning that producers and consumers are independent of each other. Producers don't need to know who the consumers are, and consumers don't need to know the producers. They communicate solely through events.

3. Event-driven Processing: Event-driven architectures focus on processing events as they occur, allowing systems to react and respond in real-time. Events can trigger various actions or workflows, enabling systems to be highly responsive and scalable.

Message-based Distributed Cloud Architecture:
In a message-based architecture, systems communicate through messages that are exchanged between components. Messages represent discrete units of communication that contain relevant data and instructions for the recipient. The architecture typically involves message producers, message queues or topics, and message consumers.

Key characteristics of a message-based distributed cloud architecture include:

1. Message Queues/Topics: Messages are sent by producers to message queues or topics, which act as intermediate storage for the messages. Consumers then retrieve messages from the queues/topics for processing.

2. Point-to-Point or Publish-Subscribe: Message-based systems can operate in either point-to-point or publish-subscribe patterns. In point-to-point communication, a message is consumed by a single consumer. In publish-subscribe communication, messages are broadcasted to multiple consumers interested in specific topics or message types.

3. Guaranteed Delivery: Message-based architectures often provide mechanisms to ensure reliable and guaranteed delivery of messages. This includes acknowledgment mechanisms, retries, and fault tolerance to handle message processing failures.

4. Message Processing: Consumers retrieve messages from the queues/topics and process them. The processing can involve various actions, such as updating databases, invoking services, or triggering other workflows.

In summary, the main difference between an event-driven distributed cloud architecture and a message-based distributed cloud architecture lies in their communication patterns. Event-driven architectures focus on reacting to events asynchronously, while message-based architectures revolve around the exchange of messages between components. Both approaches have their advantages and are suitable for different scenarios depending on the requirements of the system.