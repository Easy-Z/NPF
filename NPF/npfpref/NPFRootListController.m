#include "NPFRootListController.h"

@implementation NPFRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void) killApp {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Kill Phone App"
	message:@"Are You Sure You Want To Kill The Phone App?"
	preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *respringBtn = [UIAlertAction actionWithTitle:@"Kill"
	style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		pid_t pid;
		int status;
		const char* args[] = {"killall", "MobilePhone", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char*
		const*)args, NULL);
		waitpid(pid, &status, WEXITED);
	}];

	UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel"
	style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];

	[alert addAction:respringBtn];
	[alert addAction:cancelBtn];

	[self presentViewController:alert animated:YES completion:nil];
}

	- (void) reset {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset All Settings to Defualt"
	message:@"Are You Sure You Want To Reset All Settings to Defualt?"
	preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *resetBtn = [UIAlertAction actionWithTitle:@"Reset All Settings to Defualt"
	style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		for(PSSpecifier *specifier in [self specifiers]) {
    	[super setPreferenceValue:[specifier propertyForKey:@"default"] specifier:specifier];
    }
    [self reloadSpecifiers];
	}];

	UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel"
	style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];

	[alert addAction:resetBtn];
	[alert addAction:cancelBtn];

	[self presentViewController:alert animated:YES completion:nil];
}

@end
