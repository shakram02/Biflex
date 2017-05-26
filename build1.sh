#!/bin/bash

bison -d biflex.y 
flex biflex.l 
g++ -o parser1 lex.yy.c biflex.tab.c
