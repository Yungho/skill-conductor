# Conductor Context

The skill-conductor workspace directory is **configurable per project**. Throughout this document, `<workspace>` refers to the workspace directory (default: `skill-conductor/`).

## Configuration

Set your workspace directory name at the top of this file:
<!-- Edit the line below to match your project's workspace directory name -->
**Workspace Directory**: `skill-conductor/`

If your project uses a different name (e.g., `conductor/`), update the value above and all paths below will resolve relative to it.

## Plan References

If a user mentions a "plan" or asks about the plan, they are likely referring to the `<workspace>/tracks.md` file or one of the track plans (`<workspace>/tracks/<track_id>/plan.md`).

## Universal File Resolution Protocol

**PROTOCOL: How to locate files.**
To find a file (e.g., "**Product Definition**") within a specific context (Project Root or a specific Track):

1. **Identify Index:** Determine the relevant index file:
   - **Project Context:** `<workspace>/index.md`
   - **Track Context:**
     a. Resolve and read the **Tracks Registry** (via Project Context).
     b. Find the entry for the specific `<track_id>`.
     c. Follow the link provided in the registry to locate the track's folder. The index file is `<track_folder>/index.md`.
     d. **Fallback:** If the track is not yet registered (e.g., during creation) or the link is broken:
        1. Resolve the **Tracks Directory** (via Project Context).
        2. The index file is `<Tracks Directory>/<track_id>/index.md`.

2. **Check Index:** Read the index file and look for a link with a matching or semantically similar label.

3. **Resolve Path:** If a link is found, resolve its path **relative to the directory containing the `index.md` file**.
   - *Example:* If `<workspace>/index.md` links to `./product.md`, the full path is `<workspace>/product.md`.

4. **Fallback:** If the index file is missing or the link is absent, use the **Default Path** keys below.

5. **Verify:** You MUST verify the resolved file actually exists on the disk.

### Standard Default Paths (Project)

| Document | Default Path |
|----------|-------------|
| Product Definition | `<workspace>/product.md` |
| Tech Stack | `<workspace>/tech-stack.md` |
| Workflow | `<workspace>/workflow.md` |
| Guidelines | `<workspace>/guidelines.md` |
| References | `<workspace>/references.md` |
| Tracks Registry | `<workspace>/tracks.md` |
| Tracks Directory | `<workspace>/tracks/` |

### Standard Default Paths (Track)

| Document | Default Path |
|----------|-------------|
| Index | `<workspace>/tracks/<track_id>/index.md` |
| Specification | `<workspace>/tracks/<track_id>/spec.md` |
| Implementation Plan | `<workspace>/tracks/<track_id>/plan.md` |
| Metadata | `<workspace>/tracks/<track_id>/metadata.json` |
