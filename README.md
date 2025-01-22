# Cosmographia
## Table of Contents

- [Introduction](#introduction)
- [Stack](#stack)
- [Development](#development)
  - [Local Development](#local-development)
  - [Devcontainer](#devcontainer)
- [Rake Tasks](#rake-tasks)
- [ERBLint](#erblint)
- [License](#license)

## Introduction
**Cosmographia** is a SaaS platform for cartographers, GIS professionals, and visualization enthusiasts who share a commitment to geoconscience and bioconscience.

## Stack

- **Ruby**: 3.4.1
- **Backend**: Ruby on Rails 8
- **Frontend**: Esbuild, Hotwire
- **Database**: PostgreSQL
- **Background Jobs**: SolidQueue, mission_control-jobs
- **UI Components**: ViewComponent
- **Deployment**: Fly.io
- **Storage**: Amazon S3
- **Containerization**: Devcontainer
- **Testing**: RSpec, Capybara, FactoryBot
- **Authorization**: Pundit
- **Pagination**: Pagy
- **Payment Processing**: Stripe, Pay-Rails
- **Image Processing**: ImageProcessing

## Local Development

1. **Clone the Repository**
```bash
git clone https://github.com/thibautbaissac/cosmographia.git
cd cosmographia
```

2. **Install Dependencies**
```bash
bundle install
yarn install
```


3. **Set Up the Database**
```bash
rails db:create
rails db:migrate
rails db:seed
```
4. **Running the Application**
```bash
./bin/dev
```
Visit http://localhost:3000



## Devcontainer
If you prefer to use a development container, follow these steps:
- Install Docker: Ensure Docker is installed and running on your machine.
- Open in VS Code: Open the project in Visual Studio Code.
- Reopen in Container: Use the command palette (Ctrl+Shift+P or Cmd+Shift+P) and select Remote-Containers: Reopen in Container.

Note: If switching between Devcontainer and local development, run:
```bash
yarn install
```

## Rake Tasks
To sort YAML files in the config/locales directory:
```bash
rails sort_yaml
```

## ERBLint

ERBLint is used to find and correct linting issues in ERB templates.
Finding Issues

To identify linting issues across all ERB files:
```bash
erblint --lint-all
```

Autocorrection
To automatically correct linting issues:
```bash
erblint --lint-all --autocorrect
```

Alternatively, to autocorrect a specific file:
```bash
erblint -a app/views/training_sessions/index.html.erb
```
For a detailed list and autocorrection:
```bash
erblint -la -a
```

## License
See LICENSE
