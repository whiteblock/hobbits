CC=g++

INCLUDE=-Ilib/
VERSION=c++17
CFLAGS=-g -std=$(VERSION) -Wno-format -Wall 

FILES=main.cpp


.PHONY: clean fclean re all

all: $(OBJECTS) test
	
test: 
	$(CC) $(CFLAGS) $(FILES) -o test

clean: 
	rm -f $(OBJECTS)  $(TEST_OBJ)

fclean:
	rm -f test

re: fclean all
