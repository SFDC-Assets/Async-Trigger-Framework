
![Status](https://img.shields.io/badge/status-Beta-yellowgreen)

<h1 align="center">Asynchronous Trigger Framework</h1>
<p align="center">An alternate way to view triggers on a change event</p>

<!-- Sections below are Optional -->

---

## Overview

Saving records in Salesforce cause a series of [calculations to take place](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm), to help business logic and database updates. This is known as an Apex Transaction. As business processes get more and more defined in a Salesforce org, this Apex Transaction can start taking a while. You can reduce these transaction times and limit constraints by decoupling resource-intense, non-transactional logic from this transaction, and execute asynchronously. That means, you first execute the save, then generate an event after completion. With the combination of [Change Data Capture](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_intro.htm) and asynchronous apex triggers, you can achieve this architecture.

This framework is meant to put structure around asynchronous triggers to allow developers to write logic instead of learning the anatomy of a change event. Instead of digging into the change event object to grab IDs or find the fields fields that have changed with their new values or understand if this is a new record that was created, this framework pulls all of that into maps and works similar to synchronous trigger factories.

## Setup Instructions

There is a scratch org definition included in this project, so it can be easily spun up in a scratch org for testing. The examples are frivolous and do not map to any business requirements I have ever run into.

AsyncTriggerFactory controls the runtime of all asynchronous triggers.

AsyncTriggerBase is extended by any new asynchronous trigger handlers.

AsyncTriggerHelper holds logic to setup the async trigger base.

AccountChangeEventTrigger and Account_ATH are the examples of how to set this up.

## Maintainers
[Pete O'Connell](https://github.com/iiretepii)

## References
* [Change Data Capture Documentation](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_intro.htm)
* [Change Event Message Structure](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_message_structure.htm)
* [Developer Blog Post](https://developer.salesforce.com/blogs/2019/06/get-buildspiration-with-asynchronous-apex-triggers-in-summer-19.html)


## License
[MIT](LICENSE)