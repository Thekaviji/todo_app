//Project Architecture

lib/
├── data/
│   ├── models/                # Hive-compatible Task model & generated adapter
│   └── task_repository.dart   # Abstracts data layer (CRUD with Hive)
│
├── presentation/
│   ├── bloc/                  # BLoC for managing task state (events, states, logic)
│   ├── pages/
│   │   └── task_home_page.dart     # Main UI for listing and managing tasks
│   └── widgets/
│       ├── task_tile.dart          # UI tile for a single task
│       └── TaskFormWidget.dart     # Form widget for adding/editing tasks
│
└── main.dart                  # Entry point of the app


//