.PHONY: all run clean info rebuild

SRC_DIR = src
BUILD = build
_DEBUG = debug
_RELEASE = release
SOURCES = $(shell ls $(SRC_DIR)/*.cpp)
SOURCES_ASM = $(shell ls $(SRC_DIR)/*.asm)
PROGRAM_NAME = $(shell basename $$PWD)
CXXFLAGS += -m32 -std=c++17 -Wall -Wextra
ASMFLAGS = -f elf32
ASS = nasm

#default debug
DEBUG ?= 1

ifeq ($(DEBUG),1)
	CXXFLAGS += -DDEBUG -g
	ASMFLAGS += -g
	TARGET = $(_DEBUG)
else
	CFLAGS += -DNDEBUG
	TARGET = $(_RELEASE)
endif

BUILD_DIR = $(BUILD)/$(TARGET)
PROGRAM = $(BUILD_DIR)/$(PROGRAM_NAME)

OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
OBJECTS_ASM = $(SOURCES_ASM:$(SRC_DIR)/%.asm=$(BUILD_DIR)/%.o)

all: $(PROGRAM_NAME)

$(PROGRAM_NAME): $(PROGRAM) | $(shell rm -f $(PROGRAM_NAME))
	cp $(PROGRAM) $(PROGRAM_NAME)

$(PROGRAM): $(OBJECTS) $(OBJECTS_ASM)
	$(CXX) -o $@ $(CXXFLAGS) $^

${BUILD_DIR}:
	mkdir -p $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | ${BUILD_DIR}
	$(ASS) $(ASMFLAGS) -o $@ $<

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | ${BUILD_DIR}
	$(CXX) -c -o $@ $(CXXFLAGS) $<

run: $(PROGRAM_NAME)
	@echo Running $(PROGRAM_NAME)
	@./$(PROGRAM_NAME)

clean:
	rm -f $(PROGRAM_NAME)
	rm -rf $(BUILD)

info:
	@echo PROGRAM_NAME: $(PROGRAM_NAME)
	@echo TARGET: $(TARGET)
	@echo SOURCES: $(SOURCES)
	@echo SOURCES_ASM: $(SOURCES_ASM)
	@echo OBJECTS: $(OBJECTS)
	@echo OBJECTS_ASM: $(OBJECTS_ASM)

rebuild: clean $(PROGRAM_NAME)