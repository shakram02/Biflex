#!/bin/bash

bison -d --debug --verbose biflex.y 
flex biflex.l 
g++ -o parser1 lex.yy.c biflex.tab.c
