CC=g++

INCLUDE=-Ilib/
VERSION=c++17
CFLAGS=-g -std=$(VERSION) -Wno-format -Wall 

FILES=main.cpp

OBJS := $(FILES:.cpp=.o)
.PHONY: clean fclean re all

all: test
	
test: % : main.cpp
	$(CC) $(CFLAGS) $< -o test

clean: 
	rm -f $(OBJECTS)  $(TEST_OBJ)

fclean:
	rm -f test

re: fclean all
