% This script can be used to interactively inspect the results

[sequences, experiments] = vot_environment();

trackers = create_trackers('rpeTracker');

vot_browse(trackers, sequences, experiments);

