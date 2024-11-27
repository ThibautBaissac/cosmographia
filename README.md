# COSMOGRAPGIA


## RAKE TASKS
# Sort yaml files in config/locales
```bash
rails sort_yaml
```

## ERBLint
To find and correct linting issues:
Finding issues:
```bash
erblint --lint-all
```

Autocorrection:
```bash
erblint -a app/views/training_sessions/index.html.erb
erblint --lint-all --autocorrect
erblint -la -a
