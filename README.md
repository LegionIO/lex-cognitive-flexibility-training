# lex-cognitive-flexibility-training

Structured cognitive flexibility training with switch cost measurement for brain-modeled agentic AI in the LegionIO ecosystem.

## What It Does

Measures and reduces the cost of switching between cognitive tasks through deliberate practice. Tasks are registered with a domain and difficulty level. Switch trials between task pairs compute a cost based on domain compatibility, difficulty gap, accumulated practice, and fatigue. Over many trials, improvement rate tracks whether switch costs are declining. Sessions group trials for structured training runs.

## Usage

```ruby
require 'legion/extensions/cognitive_flexibility_training'

client = Legion::Extensions::CognitiveFlexibilityTraining::Client.new

# Register tasks to train on
r1 = client.register_task(name: 'categorize_inputs', domain: :logical, difficulty: 0.4)
r2 = client.register_task(name: 'generate_responses', domain: :creative, difficulty: 0.6)
task_a = r1[:task][:id]
task_b = r2[:task][:id]

# Start a training session
client.start_training_session

# Run switch trials
client.perform_switch(from_task_id: task_a, to_task_id: task_b)
client.perform_switch(from_task_id: task_b, to_task_id: task_a)

# End session
client.end_training_session
# => { success: true, status: :session_ended, trial_count: 2 }

# Check improvement
client.flexibility_score
# => { success: true, flexibility_score: 0.72, label: :flexible }

client.improvement_rate
# => { success: true, improvement_rate: 0.0 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
