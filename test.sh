#!/bin/sh

RED='\033[0;31m'
GREEN='\033[1;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

FAIL=0
BONUS_DOC=0
BONUS_CODE=0

echo ""
echo "Checking for mandatory files..."
echo ""

if test -f "exp_comp.ml"; then
    echo -e "${GREEN}exp_comp.ml found!"
else
    echo -e "${RED}exp_comp.ml not found!"
    FAIL=1
fi

if test -f "exp_lex.mll"; then
    echo -e "${GREEN}exp_lex.ml found!"
else
    echo -e "${RED}exp_lex.ml not found!"
    FAIL=1
fi

if test -f "exp_par.mly"; then
    echo -e "${GREEN}exp_par.ml found!"
else
    echo -e "${RED}exp_par.ml not found!"
    FAIL=1
fi

if test -f "exp_types.ml"; then
    echo -e "${GREEN}exp_types.ml found!"
else
    echo -e "${RED}exp_types.ml not found!"
    FAIL=1
fi

if test -f "fib1.mc"; then
    echo -e "${GREEN}fib1.mc found!"
else
    echo -e "${RED}fib1.mc not found!"
    FAIL=1
fi

if test -f "fib2.mc"; then
    echo -e "${GREEN}fib2.mc found!"
else
    echo -e "${RED}fib2.mc not found!"
    FAIL=1
fi

if test -f "extra.md"; then
    echo -e "${GREEN}extra.md found!"
    BONUS_DOC=1
else
    echo -e "${ORANGE}extra.md (optional) not found!"
fi

if test -f "extra.mc"; then
    echo -e "${GREEN}extra.mc found!"
    BONUS_CODE=1
else
    echo -e "${ORANGE}extra.mc (optional) not found!"
fi

if [ $FAIL == 1 ] ; then
    echo -e "${RED}Some mandatory files missing, quitting"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}All mandatory files found!"

if [ $BONUS_DOC == 1 ] && [ $BONUS_CODE == 1 ] ; then
    
    echo -e "${GREEN}All extra files found!"

else

    echo -e "${ORANGE}Some extra files (optional), missing, continuing"

fi

echo ""
echo -e "${NC}Attempting to compile exp_comp.native..."
echo ""

rm -f *cmi
rm -f *cmo
ocamlbuild -use-menhir -use-ocamlfind exp_comp.native

echo ""

if test -f "exp_comp.native"; then
    echo -e "${GREEN}exp_comp.native compiled successfully!"
else
    echo -e "${RED}exp_comp.native did not compile successfully, quitting"
    echo ""
    rm -rf _build
    exit 1
fi

echo ""
echo -e "${NC}Parsing fib1.mc..."

./exp_comp.native < fib1.mc

echo ""
echo -e "${NC}Parsing fib2.mc..."

./exp_comp.native < fib2.mc

if [ $BONUS_DOC == 1 ] && [ $BONUS_CODE == 1 ] ; then
    
    echo ""
    echo -e "${NC}Parsing extra.mc..."

    ./exp_comp.native < extra.mc
fi

echo ""
echo -e "${GREEN}All done! Cleaning up..."
echo ""

rm -f exp_comp.native
rm -rf _build
