The biggest difference between Service Bus and Event Hubs have to do with intent. EH is more transient and scalable for volume. SB is more general purpose, but is focused on tunable delivery and routing.

Event Grid is useful for getting data out of Azure when something happens on Azure say you create a blob and you want to respond to that you'd likely use EventGrid to emit a message and then I'll wire that up using any of the services on Azure (email, SMS?).

Service bus is a general purpose tool for building out messaging inside of applications. Service Bus you have a publisher/subscriber... Publisher creates a message puts it on the service bus and the message will stay on the service bus until either the message expires or the topic subscriber pulls the message and responds to it.

With event hub the producer produces the message which is put onto Event Hub, Event Hub wants to forward that onto the consumer right away without persisting for any period of time.. If there is no consumer the message is more or less dropped. Its not persisted in a way that will allow the client to connect at a future date.

That's not quite correct.. there is a way to persist the dropped messages to blob storage or a data lake.

Use case is strictly around streaming massive amounts of events. It assumes there is a consumer and is basically just brokering between the producers and consumers.

# Architecture
Similar to Service Bus but...

Instead of a publisher we call it a producer. Could potentially be thousands of producers... millions of messages... so designed to be scalable by partitioning out...

DOES NOT PERSIST LIKE A SERVICE BUS... forwards or throws (perhaps to a data lake)

![image](https://learn.microsoft.com/en-us/azure/event-hubs/media/event-hubs-about/event_hubs_architecture.png)