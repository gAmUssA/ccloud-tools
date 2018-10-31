# Confluent Cloud Tools

"As a developer, you want to build applications, not infrastructure" -- this is the pilosophy behind [Confluent Cloud](https://www.confluent.io/confluent-cloud), A resilient, scalable streaming data service based on Apache Kafka -- delivered as a fully managed service. Unlike proprietary services, Confluent Cloud offers the same open-source Kafka APIs that you know and love -- giving you access to the vibrant Kafka ecosystem that includes [Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html), [REST Proxy](https://docs.confluent.io/current/kafka-rest/docs/index.html) and [Control Center](https://docs.confluent.io/current/control-center/index.html).

The Confluent Cloud Tools is an open-source project based on [Terraform](https://www.terraform.io) that allows you to get all the tools from Confluent Platform (Schema Registry, REST Proxy, Control Center, KSQL) up-and-running in ~10 minutes. All you have to do is:

<p align="center">
    <img src="images/three_steps.png" />
</p>

And hey... it is ~10 minutes of provisioning time -- instead of coding work.

Quickstart
----------

The first thing you need to do is clone the repository. So go ahead and get yourself a copy of the Confluent Cloud Tools:

```bash
    $ git clone git@github.com:riferrei/ccloud-tools.git <ENTER>
      
```
Navigate to the folder that contains your Cloud provider implementation (i.e.: terraform/aws) and edit the 'main.tf' file. You neeed to provide the credentials from your Cloud provider, as well as the connectivity information from Confluent Cloud.