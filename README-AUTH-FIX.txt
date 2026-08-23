Elliot Qx V4.2 - Free Plan Authentication Fix

Changes:
- Reduces PBKDF2 iterations from 240,000 to 20,000 so authentication can run within the tight Cloudflare Workers Free CPU budget.
- Keeps a unique random 16-byte salt per password.
- Uses SHA-256 fixed-size timing-safe comparison for BOOTSTRAP_TOKEN.
- Keeps secure HttpOnly/Secure/SameSite session cookies and SHA-256 session token hashing.
- Version endpoint reports 4.2-free-plan-auth.

Production recommendation:
Move to Workers Paid and increase password KDF cost, or preferably use Microsoft Entra SSO/MFA for Elliot Controls.
