###############################################################################
################### MOOSE Application Standard Makefile #######################
###############################################################################
#
# Optional Environment variables
# MOOSE_DIR        - Root directory of the MOOSE project
#
###############################################################################
# Use the MOOSE submodule if it exists and MOOSE_DIR is not set
MOOSE_SUBMODULE    := $(CURDIR)/moose
ifneq ($(wildcard $(MOOSE_SUBMODULE)/framework/Makefile),)
  MOOSE_DIR        ?= $(MOOSE_SUBMODULE)
else
  MOOSE_DIR        ?= $(shell dirname `pwd`)/moose
endif

GRIFFIN_DIR ?= $(CURDIR)/griffin
GRIFFIN_CONTENT := $(shell ls $(GRIFFIN_DIR) 2> /dev/null)

# framework
FRAMEWORK_DIR      := $(MOOSE_DIR)/framework
include $(FRAMEWORK_DIR)/build.mk
include $(FRAMEWORK_DIR)/moose.mk

################################## MODULES ####################################
# To use certain physics included with MOOSE, set variables below to
# yes as needed.  Or set ALL_MODULES to yes to turn on everything (overrides
# other set variables).

HEAT_CONDUCTION    := yes
PHASE_FIELD        := yes
MISC               := yes
NAVIER_STOKES      := yes
RAY_TRACING        := yes
STOCHASTIC_TOOLS   := yes
REACTOR            := yes
THERMAL_HYDRAULICS := yes

include $(MOOSE_DIR)/modules/modules.mk
###############################################################################

# GRIFFIN
ifneq ($(GRIFFIN_CONTENT),)
  libmesh_CXXFLAGS += -DGRIFFIN_ENABLED
  # isoxml module
  APPLICATION_DIR  := $(GRIFFIN_DIR)/isoxml
  APPLICATION_NAME := isoxml
  BUILD_EXEC       := no
  include          $(FRAMEWORK_DIR)/app.mk
  ADDITIONAL_DEPEND_LIBS += $(GRIFFIN_DIR)/isoxml/lib/libisoxml-$(METHOD).la
  ADDITIONAL_INCLUDES    :=
  ADDITIONAL_APP_DEPS    :=
  ADDITIONAL_APP_OBJECTS :=
  BUILD_TEST_OBJECTS_LIB := yes
  # rattlesnake module
  APPLICATION_DIR    := $(GRIFFIN_DIR)/radiation_transport
  APPLICATION_NAME   := rattlesnake
  include            $(FRAMEWORK_DIR)/app.mk
  APPLICATION_DIR  := $(GRIFFIN_DIR)
  APPLICATION_NAME := griffin
  include          $(FRAMEWORK_DIR)/app.mk
endif

# dep apps
APPLICATION_DIR    := $(CURDIR)
APPLICATION_NAME   := external_control_example
BUILD_EXEC         := yes
GEN_REVISION       := no
include            $(FRAMEWORK_DIR)/app.mk

###############################################################################
# Additional special case targets should be added here
