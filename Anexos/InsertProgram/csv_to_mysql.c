#include <mysql/mysql.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define SERVER "localhost"
#define USER "program"
#define PASSWORD "password"
#define DATABASE "Agencia"

void finish_with_error(MYSQL *con)
{
    fprintf(stderr, "%s\n", mysql_error(con));
    mysql_close(con);
    exit(1);
}

void trim_leading_whitespace(char *str)
{
    char *start = str;

    while (isspace((unsigned char)*start))
    {
        start++;
    }

    if (start != str)
    {
        memmove(str, start, strlen(start) + 1);
    }
}

int main(int argc, const char *argv[])
{
    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s <csv_file> <table_name>\n", argv[0]);
        return 1;
    }

    MYSQL *con = mysql_init(NULL);

    if (con == NULL)
    {
        fprintf(stderr, "mysql_init() failed\n");
        exit(1);
    }

    if (mysql_real_connect(con, SERVER, USER, PASSWORD, DATABASE, 0, NULL, 0) == NULL)
    {
        finish_with_error(con);
    }

    FILE *file = fopen(argv[1], "r");
    if (!file)
    {
        fprintf(stderr, "Could not open file %s\n", argv[1]);
        return 1;
    }

    char line[1024];
    while (fgets(line, sizeof(line), file))
    {
        char *data[6];
        int i = 0;

        char *token = strtok(line, ",");
        while (token != NULL && i < 6)
        {
            trim_leading_whitespace(token);
            data[i++] = token;
            token = strtok(NULL, ",");
        }

        if (i != 6)
        {
            fprintf(stderr, "Invalid data format in line: %s\n", line);
            continue;
        }

        if (strlen(data[0]) > 30 || strlen(data[1]) > 50 || strlen(data[2]) > 15 ||
            strlen(data[3]) > 20 || strlen(data[4]) > 8 || strlen(data[5]) > 50)
        {
            fprintf(stderr, "Data too long in line: %s\n", line);
            continue;
        }

        char query[2048];
        snprintf(query, sizeof(query), 
            "INSERT INTO %s (nome, email, pass, concelho, cod_postal, rua) VALUES('%s', '%s', '%s', '%s', '%s', '%s')", 
            argv[2], data[0], data[1], data[2], data[3], data[4], data[5]);

        if (mysql_query(con, query))
        {
            finish_with_error(con);
        }
    }

    fclose(file);
    mysql_close(con);

    return 0;
}
