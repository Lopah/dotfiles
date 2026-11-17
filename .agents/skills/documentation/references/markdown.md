# Markdown documentation

For READMEs, agent instructions, and skills in this repository.

1. Open with the reader's task and put the main action before background.
2. Use short, active sentences and headings that name the task.
3. Give commands with their working directory, prerequisites, and expected
   result. Label examples that contain placeholder paths or record numbers.
4. State installation side effects before the command. Distinguish host
   installation from container validation and identify elevated operations.
5. Distinguish Linux, macOS, and Windows behavior. Document tested support
   rather than inferring it from the presence of an entry-point script.
6. Link to the owning file instead of repeating a link map, dependency list,
   SDK pin, or workflow definition.

Keep `AGENTS.md` a map of boundaries and pointers. Put ordered workflows in
skills, with a `description` stating when to load them. Resolve relative links
from the containing file and keep `.agents/skills/` authoritative rather than
duplicating content under `.claude/skills/`.
