---
name: chatgpt-share-extractor
description: Extract readable markdown transcripts from public ChatGPT share URLs. Use whenever a user pastes or references a chatgpt.com/share URL and wants the shared conversation saved, inspected, or used as source context.
---

# ChatGPT Share Extractor

Run the bundled script with exactly two args: the share link and an output directory.

```bash
python3 scripts/extract_chatgpt_share.py https://chatgpt.com/share/SHARE_ID /path/to/output-dir
```

The script always writes markdown into that directory and prints the created file path. Use the output markdown as the source for any follow-up work.
