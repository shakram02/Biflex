#!/bin/bash

bison -d example1.y 
flex example1.l 
g++ -o parser1 lex.yy.c example1.tab.c
