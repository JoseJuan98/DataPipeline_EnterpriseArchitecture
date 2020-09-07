# Pipeline, Data Models Project - Enterprise Architecture of Bergen Kommune

## Introduction
Project developed with the purpose of monitoring the enterprise environment of Bergen Kommune among the time. Because of confidentiality reasons it can be showed the code which I developed but not the data which Bergen Kommune owns. However, the data used for testing (because of being randomly created) is available.

The goal of the project is to solve the needs of the organization to be able to create a pipeline to model the Enterprise Architecture. The goal is to have a fully automated process creating a pipeline to be able to manage the data of the services and systems of the organization, being able to update this data periodically from their internal sources and by other side their own changes that the Enterprise Architectures do in a GitHub repository, which is syncronized with the data model for the Archi tool.

## Technologies 

- Python - Used for extracting the raw data from the internal sources of the company and to perform some data cleaning, also used to synchronize the data model with the GitHub repository. 
- MySQL - As the project is limited to Microsoft Azure Services, the decision had to be a DBMS that is compatible with Azure and also widely used elsewhere. 
- SQL - Used to create the data models and transform and store the data.
- GitHub - Code repository website for synchronicing the data model for Archi in the tool and in the database. Has integration to Archi, utility used by the Enterprise Architects.
- Archi - Modelling tool for the Enterprise Architecture language ArchiMate widely used within the Enterprise Architecture environment. 
- Microsoft Azure - A cloud computing platform developed by Microsoft, in which the final data models are working in a MS SQL database. Because of the compabilities and similiarities with MySQL, it has been easy to make it work.
- Shell Script (Bash) - Since the primary focus of the task has been on the logic and the transformation of the data, there has not been a large focus on the user interface. In order to execute the scripts, for creating and updating the models, it has implemented a command line utility for the Azure data lake team in Bergen Municipality.
| ![Image of Command Line Utility Login](/img/CommandUtil_Login.png) | ![Image of CommanLineUtility](/img/CommandUtil_2s.png) |
| ------------------------------------------------------------------ | ------------------------------------------------------ |
|                                                                    |                                                        |


## Design
The solution has been designed by data models within a MySQL database that are automanaged by triggers carrying out the data transformations and updates everytime that a main table is updated. In this way the MySQL database works as a data warehouse where the data only needs to be ingested in one table.It implements the start database design. The extraction and the load of the data are done in Python ,with SQLAlchemy library, and the schedules are carried out by Apache Airflow's scripts, but because of confidentiality reasons they can not be shown.

There are three data models:

- RawData **(Rådata)**. Main/center table of the database design in star, which stores the data without changes of the organization.
- Normalised model **(Normerte)**. Used by other services of the organization. The transformations of the data to create this model have dependencies with the RawData model.
- Archi model **(Preparerte)**. Model that represents the data in a ArchiMate language to be able to export this data to build a Enterprise Architecture Model into the tool Archi, used by the organization.The transformations of the data to create this model have dependencies with the Normalised model.



The current issue is to create a solution for Bergen Municipality’s Modelling Architecture based on the tool Archi which includes:

- Establish an data storage for the data
- Pull data from multiple source systems to be stored in the data structure
- Regularly updating of data when they are changed in the source systems
- Export data from the data structure to Archi(modelling tool)
- Update Archi when the data is changed
- Synchronized a GitHub repository with the Archi model
- Automatization and scheduling of the process

#### Conceptual Dataflow Diagram
The dataflow looks similar to a ETL process at the beginning, with the difference that the data models can be updated also by the changes done in the models in GitHub.

![Image of Dataflow](/img/ETL_Process.png)

### Enterprise Architecture Diagram

![Image of EA Diagram](/img/EA_Dia.png)

### Example of final model in Archi tool
This is an example of how the data model dedicated to Archi could looks like after exporting the data through the pipeline into the Archi tool.

![Image of Example of Archimate](/img/Archi_Ex.png)
