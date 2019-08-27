static_obj += $(OBJECT_PATH)/sub.o  $(OBJECT_PATH)/div.o
dynamic_obj += $(OBJECT_PATH)/add.o $(OBJECT_PATH)/mul.o

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
pro_path:=$(shell dirname $(mkfile_path))
$(warning $(mkfile_path))
$(warning $(pro_path))

HFLAGS += -I add/ -I sub/ -I mul/ -I div/
  
BINARY_PATH ?= out/bin
LIB_PATH    ?= out/lib
OBJECT_PATH ?= out/objs
TARGET1      ?= $(BINARY_PATH)/main_1.exe
TARGET2      ?= $(BINARY_PATH)/main_2.exe
TARGET       ?= $(BINARY_PATH)/main.exe

#创建目录
$(BINARY_PATH) $(OBJECT_PATH) $(LIB_PATH):
	mkdir -p $@

#生成目标文件
$(OBJECT_PATH)/add.o : add/add.c
	cc -c add/add.c -o $(OBJECT_PATH)/add.o
$(OBJECT_PATH)/sub.o : sub/sub.c
	cc -c sub/sub.c -o $(OBJECT_PATH)/sub.o
$(OBJECT_PATH)/mul.o : mul/mul.c  
	cc -c mul/mul.c -o $(OBJECT_PATH)/mul.o
$(OBJECT_PATH)/div.o : div/div.c
	cc -c div/div.c -o $(OBJECT_PATH)/div.o

#生成动态库
$(LIB_PATH)/libadd_mul.so :  $(dynamic_obj)
	cc -shared -fPIC -o $(LIB_PATH)/libadd_mul.so  $(OBJECT_PATH)/add.o $(OBJECT_PATH)/mul.o

#生成静态库
$(LIB_PATH)/libdiv_sub.a : $(OBJECT_PATH)/div.o $(OBJECT_PATH)/sub.o 
	ar -cr -o $(LIB_PATH)/libdiv_sub.a  $(OBJECT_PATH)/div.o $(OBJECT_PATH)/sub.o

#使用静态库生成可执行文件：
$(TARGET1) : main.c $(LIB_PATH)/libdiv_sub.a
	cc main.c -o $(BINARY_PATH)/main_1.exe -L out/lib/ -ldiv_sub $(HFLAGS)

#使用动态库生成可执行文件：
$(TARGET2) : main.c $(LIB_PATH)/libadd_mul.so
	cc main.c -o $(TARGET2) $(pro_path)/out/lib/libadd_mul.so $(HFLAGS) 

#使用静态库和动态库一起生成可执行文件：
$(TARGET) : main.c $(LIB_PATH)/libdiv_sub.a $(LIB_PATH)/libadd_mul.so
	cc main.c -o $(TARGET)  $(pro_path)/out/lib/libadd_mul.so   -L out/lib/ -ldiv_sub $(HFLAGS)

.PHONY:     all clean  prepare build hello post-build
all:        hello prepare build post-build
clean:      ;rm -rf out
hello:      ;@echo ==== start, $(shell date) ====
prepare:    $(BINARY_PATH) $(OBJECT_PATH) $(LIB_PATH)
build:      $(TARGET)
post-build: ;@echo ==== done, $(shell date) ====


