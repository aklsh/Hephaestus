#
# Makefile
# Akilesh Kannan, 2020-12-15 14:35
#

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category

HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^(\w+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (keys %help) { \
	print "$$_:\n"; $$sep = " " x (20 - length $$_->[0]); \
	print "  $$_->[0]$$sep$$_->[1]\n" for @{$$help{$$_}}; \
	print "\n"; }

help:           ##@miscellaneous Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

# Everything below is an example

target00:       ##@foo This message will show up when typing 'make help'
	@echo "does nothing"

target01:       ##@foo This message will also show up when typing 'make help'
	@echo "does something"

# Remember that targets can have multiple entries (if your target specifications are very long, etc.)
target02:       ## This message will show up too!!!
target02: target00 target01
	@echo "does even more"


multiCycle: ##@foo build multi-cycle cpu
	@echo "yet to do"
