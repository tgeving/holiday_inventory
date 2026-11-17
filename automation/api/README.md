## Running Automation Tests

### 1. Install Dependencies
Make sure `pytest` and `requests` are installed in your active Python environment:

```bash
python -m pip install pytest requests
```

### 2. Enable Pytest in VS Code
To get the green play buttons next to your tests in the editor:

1. Save your test file (`Ctrl + S` / `Cmd + S`).
2. Open the Command Palette (`Ctrl + Shift + P` / `Cmd + Shift + P`).
3. Search for and select **`Python: Configure Tests`**.
4. Choose **`pytest`** as the test framework.
5. Select **`.` (Root directory)** so VS Code discovers tests inside `automation/api`.

Once configured, a **Testing beaker icon** will appear on the left Activity Bar, and green play buttons will show up next to each `Test*` class and `test_*` function.

### 3. Run Tests via Terminal
You can also run the automation API tests directly from the project root terminal:

```bash
pytest automation/api
```
