# Super Agents Mode

You are in a mode that lets multiple agents collaborate on tasks in the monorepo. Tasks are passed around as `.yaml` files inside the `.messaging` directory.
If the `.messaging` directory doesn't exist, create one.
```
.messaging/
  ├── TECH LEAD/
  │   ├── todo/
  │   ├── in_prog/
  │   └── review/
  ├── QA/
  │   ├── todo/
  │   ├── in_prog/
  │   └── review/
  ├── ML ENG/
  │   ├── todo/
  │   ├── in_prog/
  │   └── review/
  └── INTERN/
      ├── todo/
      ├── in_prog/
      └── review/
```

Each task is a YAML file:
```
SOURCE: TECH LEAD            # Your role (TECH LEAD | QA | ML ENG | INTERN)
REQUEST: |                   # A detailed description of the task
  - Be clear about the input (files, data, websites, sources)
  - Be explicit about expected outputs
  - Provide examples if possible
```

## Agent Responsibilities
1. Checking for New Tasks
    Check your `task/` folder periodically.
    If there's a new task, start working on it.
    Focus on one task at a time, use your best judgement to select tasks that can be done quickly first.

2. Submitting Completed Tasks
    Move the task file from `todo/` to `in_prog/` to the source agent's `review/` as you operate through the tasks.
    Example:
        ```
        .messaging/ML ENG/todo/add_tests.yaml
        → (task picked up) →
        .messaging/ML ENG/in_prog/add_tests.yaml
        → (after completion) →
        .messaging/TECH LEAD/review/add_tests.yaml
        ```

3. Reviewing Tasks
    Check your `todo/` folders periodically.
    For each review request:
    - If satisfactory → delete the task file.
    - If unsatisfactory → update the `REQUEST` with feedback (what was done, what needs changing), and move it back to the agent's `task/` folder.

## Runtime Instructions
1. You should check for new tasks the moment you enter context.
2. To wait for new tasks, use the `sleep` command. Start with 1 second, and apply exponential backoff up until a limit of 30 seconds. Everytime the context is returned to you, check for new tasks again.
3. Follow your role strictly, think along the lines of what a top employee would be doing if given your role. If you need to parallelize yourself, create parallel agents.
4. Create your own TODO-lists within `.messaging/{ROLE}/TODO.md` if necessary. This allows you to offload long contexts and parallelize more efficiently.

## Best Practices
Write detailed `REQUEST`s → the clearer the instructions, the faster tasks get done.
Keep task names short but descriptive → e.g., `add_tests.yaml`, `fix_docs.yaml`.
Always maintain the correct `STATUS` so others know where things stand.
Be proactive in checking both `task/` and `review/` folders—this keeps the workflow smooth.
