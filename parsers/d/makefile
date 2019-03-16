CC=dmd

CFLAGS=-g 

LIB_FILES= ewp.d 
LIB_OBJ= $(LIB_FILES:.d=.o)

FILES= main.d 

OBJS := $(FILES:.d=.o)
.PHONY: clean fclean re all

all: $(LIB_OBJ) test
	
test: % : main.d
	$(CC) $(CFLAGS) $< $(LIB_OBJ)

clean: 
	rm -f $(OBJECTS)  

fclean:
	rm -f test

re: fclean all

$(LIB_OBJ): %.o : %.d
	$(CC) $(CFLAGS) -c $< $@