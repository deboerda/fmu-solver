# Examples

This public repository does **not** ship customer or proprietary `.fmu` models.

1. Obtain an FMI 2.0 `.fmu` you have rights to run.
2. Place it in a local `FMU/` folder next to the launcher (or browse from the GUI).
3. Copy `ParamFilter.example.xml` → `../ParamFilter.xml` and edit IDs for your telemetry (optional).
4. Copy `sync_fields.example.json` → `../sync_fields.json` and align `name` with FMU variable names (optional).

No sample FMU is bundled — bring your own rights-cleared model.
