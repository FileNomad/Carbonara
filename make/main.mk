ifeq ($(OS), Windows_NT)
    UNAME := Windows
else
    UNAME := $(shell uname -s)
endif

CXX := g++
CXX_FLAGS := -ggdb3 -Og -MD -MP -std=c++17 -DDEBUG -D_FORTIFY_SOURCE=2 -fno-common -fstack-protector-strong
WARNINGS := -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Wundef -Wclobbered -Wdeprecated -Wmultichar -Wuninitialized -Wunreachable-code -Wstrict-aliasing -Wreturn-type -Wtype-limits -Wformat-security -Wpointer-arith -Wmaybe-uninitialized -Wempty-body -Wdouble-promotion -Wcast-qual -Wcast-align -Wfloat-equal -Wlogical-op -Wduplicated-cond -Wshift-overflow=2 -Wformat=2
INCLUDES := -Iprog/include

ifeq ($(UNAME), Windows)
    ECHO := echo -e
    TARGET_PLATFORM_DIR := bin/windows
    EXECUTABLE_FILE := bin/windows/Carbonara.exe 
else ifeq ($(UNAME), Linux)
    ECHO := echo
    TARGET_PLATFORM_DIR := bin/linux
    EXECUTABLE_FILE := bin/linux/Carbonara.out
endif

PROG_SRC_DIR := prog/src
PROG_INCLUDE_DIR := prog/include
BIN_DIR := bin
OBJ_DIR := bin/obj
CPP_SRC_FILES := $(wildcard $(PROG_SRC_DIR)/*.cpp)
HPP_SRC_FILES := $(wildcard $(PROG_INCLUDE_DIR)/*.hpp)
INL_SRC_FILES := $(wildcard $(PROG_INCLUDE_DIR)/*.inl)
OBJ_FILES := $(patsubst $(PROG_SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC_FILES))
DEP_FILES := $(patsubst $(OBJ_DIR)/%.o, $(OBJ_DIR)/%.d, $(OBJ_FILES))

build: $(EXECUTABLE_FILE)
prepare: dirs
utility: compile_commands clangd clang-format
clean: delete

dirs:
	@if [ ! -d $(BIN_DIR) ]; then mkdir -p $(BIN_DIR); $(ECHO) "WRITE | $(BIN_DIR)"; fi
	@if [ ! -d $(OBJ_DIR) ]; then mkdir -p $(OBJ_DIR); $(ECHO) "WRITE | $(OBJ_DIR)"; fi
	@if [ ! -d $(TARGET_PLATFORM_DIR) ]; then mkdir -p $(TARGET_PLATFORM_DIR); $(ECHO) "WRITE | $(TARGET_PLATFORM_DIR)"; fi

$(OBJ_DIR)/%.o: $(PROG_SRC_DIR)/%.cpp
	@$(CXX) $(CXX_FLAGS) $(WARNINGS) $(INCLUDES) -c $< -o $@
	@$(ECHO) "CXX   | $@"
-include $(DEP_FILES)

$(EXECUTABLE_FILE): $(OBJ_FILES)
	@$(CXX) $(CXX_FLAGS) $(WARNINGS) $(INCLUDES) $^ -o $@
	@$(ECHO) "LINK  | $@"

delete:
	@if [ -d $(OBJ_DIR)/ ]; then rm -r $(OBJ_DIR); $(ECHO) "RM    | $(OBJ_DIR)"; fi
	@if [ -f $(EXECUTABLE_FILE) ]; then rm -r $(EXECUTABLE_FILE); $(ECHO) "RM    | $(EXECUTABLE_FILE)"; fi

