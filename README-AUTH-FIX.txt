Elliot Qx V4.1 Authentication Fix

This patch fixes an issue in V4 where failed POST requests (including bootstrap/login errors) were incorrectly treated as offline-queued field updates. That made a failed administrator bootstrap appear successful.

Upload all files in this folder to the GitHub repository root, replacing existing versions. Cloudflare should redeploy automatically.

After deployment:
1. Hard refresh the Qx URL (Ctrl+F5).
2. Complete the first administrator setup again.
3. If setup fails, the real Cloudflare error will now be displayed instead of being hidden.

Important: The server still uses PBKDF2-240000 for password hashing. On Workers Free, the 10ms CPU limit may be too low for this secure password KDF. Workers Paid allows substantially more CPU time per request and is recommended for production custom authentication.
