
![Status](https://img.shields.io/badge/status-Beta-yellowgreen)

<h1 align="center">Asynchronous Trigger Framework</h1>
<p align="center">An alternate way to view triggers on a change event</p>

<!-- Sections below are Optional -->

---

## Overview

Saving records in Salesforce cause a series of [calculations to take place](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm), to help business logic and database updates. This is known as an Apex Transaction. As business processes get more and more defined in a Salesforce org, this Apex Transaction can start taking a while. You can reduce these transaction times and limit constraints by decoupling resource-intense, non-transactional logic from this transaction, and execute asynchronously. That means, you first execute the save, then generate an event after completion. With the combination of [Change Data Capture](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_intro.htm) and asynchronous apex triggers, you can achieve this architecture.

This framework is meant to put structure around asynchronous triggers to allow developers to write logic instead of learning the anatomy of a change event. Instead of digging into the change event object to grab IDs or find the fields fields that have changed with their new values or understand if this is a new record that was created, this framework pulls all of that into maps and works similar to synchronous trigger factories.

## Setup Instructions

There is a scratch org definition included in this project, so it can be easily spun up in a scratch org for testing. To get strated with Salesforce DX [see this trailhead module](https://trailhead.salesforce.com/en/content/learn/projects/quick-start-salesforce-dx). To setup the project and get testing, you spin up the org from this definition.

The example included in this repo is using the Account object and a trigger on the AccountChangeEvent. The setup for Change Data Capture is located in setup under `Integrations > Change Data Capture` ([trailhead module on Change Data Capture basics](https://trailhead.salesforce.com/en/content/learn/modules/change-data-capture)).

The two most important classes in the repository are the `AsyncTriggerFactory` and `AsyncTriggerHandlerBase`. Creating an async trigger using this framework is as easy as calling the factory from a ChangeEvent trigger, then creating a handler class that is named correctly. Sounds exciting!!! I know! Here is an example using Account:

Calling the trigger factory from a change event trigger.
```java
trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    AsyncTriggerFactory.initialize(SObjectType.Account);
}
```
Creating a trigger that is named correctly. You'll notice that the class is named is `Account_ATH`. The naming convention is `<object name> + '_ATH'`. If you had a custom object named `Tiger Asset Line Item` and the API name is `Tiger_Asset_Line_Item__c`, the async trigger handler would be named `Tiger_Asset_Line_Item_ATH`.
```java
public with sharing class Account_ATH extends AsyncTriggerHandlerBase {

    public override void isInsert(Map<Id,SObject> newMap) {
        AccountingService.largeCalculation(newMap);
    }

    public override void isUpdate(Map<Id,SObject> newMap) {
        AccountingService.largeCalculation(newMap);
    }
}
```

UML of project
![Asynchronous Trigger Factory UML](/images/AsyncTriggerFactory-UML.svg)

## Maintainers
[Pete O'Connell](https://github.com/iiretepii)

## References
* [Event Driven Architectures Developer Blog Post]()
* [Change Data Capture Documentation](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_intro.htm)
* [Change Event Message Structure](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_message_structure.htm)
* [Async Triggers Developer Blog Post](https://developer.salesforce.com/blogs/2019/06/get-buildspiration-with-asynchronous-apex-triggers-in-summer-19.html)


## License
[MIT](LICENSE)