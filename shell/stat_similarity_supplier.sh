#!/usr/bin/env bash

HOST="127.0.0.1"
PORT=3306
USER="root"
PASSWORD="suxin@2017"
DATABASE="db_lvfang"
TIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`

LOG="/data/logs/script/REAL_STATUS_${DATE}.LOG"


function DoStat() {
    SQL="select supplier_code from t_supplier;"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       echo "[$TIMESTAMP][WARNNING][Has no supplier to doing]" >> $LOG
       return
    fi

    for ITEM in ${VALUES}
    do
        `QuerySimilaritySupplier ${ITEM}`
    done
}

function QuerySimilaritySupplier() {
    SUPPLIER_CODE=$1

    SQL="select product_code from v_product_supplier where supplier_code='$SUPPLIER_CODE';"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       echo "[$TIMESTAMP][WARNNING][Has no product_code to doing for $SUPPLIER_CODE]" >> $LOG
       return
    fi

    let PRODUCT_CODES=""

    for ITEM in ${VALUES}
    do
       let PRODUCT_CODES="${PRODUCT_CODES},${ITEM}"
    done

    let PRODUCT_CODES="(${PRODUCT_CODES})"

    `QuerySimilaritySupplier ${PRODUCT_CODES} ${SUPPLIER_CODE}`
}


function QuerySimilarityProduct() {
    PRODUCT_CODES=$1
    SUPPLIER_CODE=$2

    SQL="select supplier_code from v_product_supplier where product_code in $PRODUCT_CODES;"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       echo "[$TIMESTAMP][WARNNING][Has no supplier to doing for $PRODUCT_CODES]" >> $LOG
       return
    fi

    for ITEM in ${VALUES}
    do
       let PRODUCT_CODES="${PRODUCT_CODES},${ITEM}"
    done

    let PRODUCT_CODES="(${PRODUCT_CODES})"
}