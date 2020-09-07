# Pipeline, Data Models Project - Enterprise Architecture of Bergen Kommune

## Introduction
Project developed with the purpose of monitoring the enterprise environment of Bergen Kommune among the time. Because of confidentiality reasons it can be showed the code which I developed but not the data which Bergen Kommune owns. However, the data used for testing (because of being randomly created) is available.

The goal of the project is to solve the needs of the organization to be able to create a pipeline to model the Enterprise Architecture. The goal is to have a fully automated process creating a pipeline to be able to phase out the existing method of solving the issue, which is done manually.

## Design
The solution has been designed by data models within a MySQL database that are automanaged by triggers carrying out the data transformations and updates everytime that a main table is updated. In this way the MySQL database works as a data warehouse where the data only needs to be ingested in one table.It implements the start database design. The schedules are carried out by Apache Airflow's scripts, but because of confidentiality reasons they can not be shown.


The current issue is to create a solution for Bergen Municipality’s Modelling Architecture based on the tool Archi. This includes:

- Establish an data storage for the data
- Pull data from multiple source systems to be stored in the data structure
- Regularly updating of data when they are changed in the source systems
- Export data from the data structure to Archi(modelling tool)
- Update Archi when the data is changed
- Synchronized a GitHub repository with the Archi model
- Automatization and scheduling of the process

