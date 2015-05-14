#!/sbin/sh
(
HOME=/tmp /tmp/sqlite3 /data/data/com.android.providers.settings/databases/settings.db << EOF

BEGIN EXCLUSIVE TRANSACTION;

DELETE FROM global WHERE name = 'preferred_network_mode';
DELETE FROM global WHERE name = 'preferred_network_mode1';

INSERT INTO global (name, value) VALUES ('preferred_network_mode', 10);
INSERT INTO global (name, value) VALUES ('preferred_network_mode1', 10);

END TRANSACTION;

VACUUM;

EOF
) || exit 1
