% This script can be used to pack the results and submit them to a challenge.

[sequences, experiments] = vot_environment();

tracker = create_tracker('rpeTracker');

vot_pack(tracker, sequences, experiments);

