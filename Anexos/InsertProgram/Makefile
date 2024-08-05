# Variables
CC = gcc
CFLAGS = -I/usr/include/mysql
LDFLAGS = -L/usr/lib/mysql -lmysqlclient
TARGET = csv_to_mysql
SRC = csv_to_mysql.c

# Rules
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)

.PHONY: all clean
