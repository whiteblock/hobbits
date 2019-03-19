CC=gcc

INCLUDE=-Ilib/
VERSION=c11
CFLAGS=-g -std=$(VERSION) -Wno-format -Wall 

FILES=main.c


.PHONY: clean fclean re all

all: $(OBJECTS) test
	
test: 
	$(CC) $(CFLAGS) $(FILES) -o test

clean: 
	rm -f $(OBJECTS)  $(TEST_OBJ)

fclean:
	rm -f test

re: fclean all
