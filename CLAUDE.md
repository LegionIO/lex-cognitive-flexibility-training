# lex-cognitive-flexibility-training

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-flexibility-training`

## Purpose

Provides structured training trials for reducing cognitive task-switching costs. Tasks are registered with domain and difficulty, then switch trials are performed between pairs of tasks. Each trial computes a switch cost based on domain similarity, difficulty gap, practice discount, and fatigue penalty. Over many trials, the improvement rate metric tracks whether switch costs are declining.

## Gem Info

| Field | Value |
|---|---|
| Gem name | `lex-cognitive-flexibility-training` |
| Version | `0.1.0` |
| Namespace | `Legion::Extensions::CognitiveFlexibilityTraining` |
| Ruby | `>= 3.4` |
| License | MIT |
| GitHub | https://github.com/LegionIO/lex-cognitive-flexibility-training |

## File Structure

```
lib/legion/extensions/cognitive_flexibility_training/
  cognitive_flexibility_training.rb  # Top-level require
  version.rb                         # VERSION = '0.1.0'
  client.rb                          # Client class
  helpers/
    constants.rb                     # Difficulty levels, domains, label maps
    training_task.rb                 # TrainingTask value object
    switch_trial.rb                  # SwitchTrial value object
    flexibility_engine.rb            # Engine: tasks, trials, sessions
  runners/
    cognitive_flexibility_training.rb # Runner module
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `MAX_TASKS` | 100 | Task registry cap |
| `MAX_TRIALS` | 1000 | Trial history cap |
| `MAX_SESSIONS` | 50 | Session history cap |
| `DEFAULT_SWITCH_COST` | 0.3 | Baseline cost before adjustments |
| `IMPROVEMENT_RATE` | 0.02 | Not enforced; documents intent |
| `FATIGUE_RATE` | 0.01 | Fatigue penalty growth rate per trial |
| `DIFFICULTY_LEVELS` | array | `trivial`, `easy`, `moderate`, `hard`, `extreme` |
| `TASK_DOMAINS` | array | `linguistic`, `spatial`, `numerical`, `logical`, `emotional`, `social`, `creative` |
| `SWITCH_COST_LABELS` | hash | `severe` (0.8+) through `minimal` |
| `FLEXIBILITY_LABELS` | hash | `highly_flexible` (0.8+) through `inflexible` |
| `PROGRESS_LABELS` | hash | `mastered` (0.8+) through `beginner` |

## Helpers

### `TrainingTask`

Registered task with domain and difficulty.

- `initialize(name:, domain:, difficulty: 0.5)` — generates ID
- `practice!` — increments `practice_count`
- `baseline_performance` — starting accuracy based on difficulty
- `to_h`

### `SwitchTrial`

Captures outcome of a single task switch.

- `initialize(from_task_id:, to_task_id:, switch_cost:, accuracy:)` — generates ID + timestamp
- `costly?` — `switch_cost >= 0.5`
- `successful?` — `accuracy >= 0.6`
- `switch_cost_label` — resolves from `SWITCH_COST_LABELS`
- `to_h`

### `FlexibilityEngine`

- `register_task(name:, domain:, difficulty: 0.5)` — returns task or error hash
- `perform_switch(from_task_id:, to_task_id:)` — computes cost (domain penalty + difficulty gap - practice discount + fatigue penalty), records trial
- `start_session`, `end_session` — groups trials into sessions
- `average_switch_cost(window: 50)`, `switch_cost_between(from_id:, to_id:)`
- `improvement_rate` — (early average - recent average) / early average
- `flexibility_score` — `1.0 - average_switch_cost`
- `hardest_switches(limit: 5)`, `easiest_switches(limit: 5)`
- `training_report` — full stats with labels and ratios

## Runners

**Module**: `Legion::Extensions::CognitiveFlexibilityTraining::Runners::CognitiveFlexibilityTraining`

| Method | Key Args | Returns |
|---|---|---|
| `register_task` | `name:`, `domain:`, `difficulty: 0.5` | `{ success:, task: }` |
| `perform_switch` | `from_task_id:`, `to_task_id:` | `{ success:, trial: }` |
| `start_training_session` | — | `{ success:, status: :session_started }` |
| `end_training_session` | — | `{ success:, trial_count: }` |
| `average_switch_cost` | `window: 50` | `{ average_switch_cost:, label: }` |
| `switch_cost_between` | `from_task_id:`, `to_task_id:` | `{ average_switch_cost:, label: }` |
| `flexibility_score` | — | `{ flexibility_score:, label: }` |
| `improvement_rate` | — | `{ improvement_rate: }` |
| `hardest_switches` | `limit: 5` | `{ switches:, count: }` |
| `easiest_switches` | `limit: 5` | `{ switches:, count: }` |
| `training_report` | — | Full report |
| `list_tasks` | — | `{ tasks:, count: }` |
| `get_task` | `task_id:` | `{ success:, task: }` |
| `list_trials` | — | `{ trials:, count: }` |

Private: `flexibility_engine` — memoized `FlexibilityEngine`. Optional `engine:` param for test injection.

## Integration Points

- **`lex-cognitive-flexibility`**: Training measures and reduces switch cost; `lex-cognitive-flexibility` tracks live operating state. They are complementary and independent.
- **`lex-cognitive-fatigue-model`**: Fatigue accumulates over trials via the `FATIGUE_RATE * trial_count` penalty in switch cost computation. High trial counts gradually increase costs without rest.

## Development Notes

- Switch cost computation: `DEFAULT_SWITCH_COST + domain_penalty + difficulty_gap - practice_discount + fatigue_penalty`. Domain penalty is 0.2 for cross-domain switches; same-domain is 0.0.
- `improvement_rate` returns 0.0 with fewer than 4 trials.
- `IMPROVEMENT_RATE` constant (0.02) is defined but not enforced; it documents design intent.
- In-memory only.

---

**Maintained By**: Matthew Iverson (@Esity)
