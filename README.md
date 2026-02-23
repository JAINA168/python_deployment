Snowflake → Liquibase Incremental Export Workflow

Overview

This repository supports controlled promotion of manual Snowflake database changes using:
Snowflake (DEV database)
Liquibase
Jenkins
GitHub Pull Requests

The process automatically exports incremental database changes from Snowflake DEV into Git branches while keeping:
✅ Full developer review control
✅ Manual PR approval and merge process
✅ Environment-based promotion (DEV → QA → PROD)


High Level Flow

Developers make manual changes in Snowflake DEV.
Examples:
CREATE / ALTER Views or Tables
Procedures or Functions
Data fixes (INSERT / UPDATE / MERGE etc.)
Jenkins job Export Incremental DB Changes is triggered manually.
Jenkins:
Detects only new changes since last export
Exports changes using Liquibase
Separates them into folders:
snowflake/ddls/
snowflake/dmls/
snowflake/procs/
Creates and pushes a new Git branch.
Developers:
Review exported scripts.
Modify DML or Procedures if required.
Remove unwanted scripts if necessary.
Developers manually:
Create Pull Request.
Merge into target environment branch.
Jenkins Liquibase pipeline deploys automatically.


Repository Structure
snowflake/
│
├── ddls/          → Schema changes (DDL)
├── dmls/          → Data changes (DML)
├── procs/         → Procedures / Functions
│
├── snapshots/     → Liquibase checkpoint snapshots (AUTO GENERATED)
│
├── changelog_sf.xml
└── liquibase.properties


Liquibase Changelog

snowflake/changelog_sf.xml automatically includes all changes.
Example:
<includeAll path="ddls" relativeToChangelogFile="true"/>
<includeAll path="dmls" relativeToChangelogFile="true"/>
<includeAll path="procs" relativeToChangelogFile="true"/>
This means:
Any SQL file added inside these folders will automatically deploy.


Incremental Export Concept

The system maintains a snapshot checkpoint per schema:
snowflake/snapshots/<SCHEMA>.json
This snapshot represents:
“Last exported database state.”
Each export run compares:
Offline Snapshot (Git)
         VS
Live Snowflake DEV Schema
Liquibase generates only the difference.
Result:
✅ Only new changes are exported.


Jenkins Export Job

Parameter:
Export_From_DB = Yes
When executed:
Jenkins creates new branch:
db-export-YYYYMMDD_HHMM
Example:
db-export-20260223_1105


What Gets Exported

DDL

Examples:
CREATE VIEW
ALTER TABLE
GRANTS
ALTER TASK

Saved under:
snowflake/ddls/


DML

Examples:
INSERT
UPDATE
DELETE
MERGE
COPY INTO

Saved under:
snowflake/dmls/
⚠ Developers should review DML carefully before promotion.


Procedures / Functions

Examples:
CREATE OR REPLACE PROCEDURE
CREATE FUNCTION

Saved under:
snowflake/procs/


DROP Statements

DROP operations are intentionally blocked during export.
Reason:
Prevent accidental destructive deployments.

If required:
Developers must manually add DROP statements in PR.


First Run Behaviour

If snapshot does not exist:
Jenkins creates baseline snapshot only.
No export happens.

Next run onwards:
Incremental exports begin.


Developer Responsibilities

After export branch is created:
Developers should:
Review SQL scripts.
Modify DML logic if required.
Validate procedure logic.
Remove unwanted changes.

Then:
Raise Pull Request manually.


Promotion Strategy

You decide where to promote.
Examples:
Export Branch → DEV
Export Branch → QA
Export Branch → PROD
Promotion is controlled entirely through PR merge.


Deployment

After merge:
Jenkins Liquibase pipeline automatically executes:
liquibase update
Liquibase applies only new changeSets.


Best Practices

Recommended:
Run export job soon after manual DB changes.
Avoid grouping many unrelated DB changes in one export.
Review DML carefully for environment differences.
Do not manually edit snapshot JSON files.


Troubleshooting

No Files Exported

Possible reasons:
No DB changes since last export.
Only DROP statements detected (blocked).
Snapshot baseline just created.


Multiple Changes Exported Together

Export captures:
Everything changed since last snapshot.
Run export job more frequently for smaller batches.


Summary

This workflow provides:
Automated incremental capture.
Liquibase controlled deployments.
Full manual approval governance.
Flexible environment promotion.


End of Document
:::
