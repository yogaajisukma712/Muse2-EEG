#!/usr/bin/env python
"""Test Flask app routes"""

import sys
sys.path.insert(0, '/home/ubuntu/Documents/Penelitian/EEG Muse')

from app import app

# Print all registered routes
print("\n✅ Flask App Routes:")
print("=" * 60)
for rule in app.url_map.iter_rules():
    print(f"{rule.endpoint:30} {rule.rule:30}")

print("\n" + "=" * 60)
print(f"Total routes: {len(list(app.url_map.iter_rules()))}")

# Check specific routes
routes_to_check = ['/download', '/api/apk/list', '/api/apk/upload']
print("\n✅ Checking required routes:")
for route in routes_to_check:
    found = any(str(rule.rule) == route for rule in app.url_map.iter_rules())
    status = "✅" if found else "❌"
    print(f"{status} {route}")
