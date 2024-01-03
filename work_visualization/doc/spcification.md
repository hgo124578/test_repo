## Purpose
When the sprint is completed, compare the sprint work results with the baseline (sprint plan) and measure the work performance.

## Key metrics
For each sprint, we measure the following metrics for members and teams.

| Data                   | Description                                                                                                                                    |
|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| Planned point          | Planned point value at the start of the sprint.                                                                                                |
| Accepted point         | Point value accepted in ths Sprint. Measure the value for Planned points and the value for all points accepted in the Sprint.                  |
| Accepted ratio         | Percentage of Accepted points in the sprint point value. Measure for planned points and for all points in the sprint.                          |
| Cost performance index | Cost performance value for accepted issues. Calculated by dividing point by spent.  Measure for planned points and for all points in a sprint. |


## Data source
At the start and end of a Sprint, collect the following data from Jira and store it in the database.
Data at the start(Plan) is collected based on the sprint value, and data at the end(Result) is collected from work logs entered during the sprint period.

| Data         | Description                         |
|--------------|-------------------------------------|
| name         | Original data on Jira.              |
| sprint       | Original data on Jira.              |
| issue.key    | Original data on Jira.              |   
| status       | Original data on Jira.              |
| summary      | Original data on Jira.              |
| story point  | Original data on Jira.              |
| sp_h         | Story points converted to hours.    |
| spent_sprint | Total work log in sprint for issue. |
| spent_all    | Sum of all work logs for issue.     |

## Visualization
Sprint result: TBD. <br>
Result history: TBD. <br>

