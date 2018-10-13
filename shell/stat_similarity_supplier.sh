#!/usr/bin/env bash

HOST="127.0.0.1"
PORT=3306
USER="root"
PASSWORD="suxin@2017"
DATABASE="db_lvfang"
TIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`

LOG="./SQL_STATUS_${DATE}.LOG"

function UpdateSupplierProducts() {
    SUPPLIER_CODE1=$1
    SUPPLIER_CODE2=$2
    PRODUCT_CODES=$3
    PRODUCT_COUNT=$4

    `echo "[$TIMESTAMP][DEBUG][SUPPLIER_CODE1:${SUPPLIER_CODE1} PRODUCT_CODES:${PRODUCT_CODES} PRODUCT_COUNT:${PRODUCT_COUNT} SUPPLIER_CODE2:${SUPPLIER_CODE2}]" >> $LOG`
    SQL="select concat(product_id,',',product_code, ',', product_name_cn,',',product_name_en,',',product_cas,',',molecular_formula,',',molecular_weight,',',HS_Code,',',category,',',purpose) from t_product where product_code in ($PRODUCT_CODES);"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       `echo "[$TIMESTAMP][WARNNING][Has no products to doing for $PRODUCT_CODES SQL:${SQL}]" >> $LOG`
       return
    fi

    PRODUCT_LIST=""

    for ITEM in ${VALUES}
    do

        OLD_IFS=$IFS
        IFS=','
        arr=($ITEM)
        IFS=$OLD_IFS

        len=${#PRODUCT_LIST}

        if [ "$len" -eq "0" ]; then
            PRODUCT_LIST="{"
            PRODUCT_LIST="${PRODUCT_LIST}\"product_id\":\"${arr[0]}\",\"product_code\":\"${arr[1]}\",\"product_name_cn\":\"${arr[2]}\",\"product_cas\":\"${arr[3]}\","
            PRODUCT_LIST="${PRODUCT_LIST}\"molecular_formula\":\"${arr[4]}\",\"molecular_weight\":\"${arr[5]}\",\"HS_Code\":\"${arr[6]}\",\"category\":\"${arr[7]}\","
            PRODUCT_LIST="${PRODUCT_LIST}\"purpose\":\"${arr[8]}\""
            PRODUCT_LIST="${PRODUCT_LIST}}"
        else
            PRODUCT_LIST="${PRODUCT_LIST},{"
            PRODUCT_LIST="${PRODUCT_LIST}\"product_id\":\"${arr[0]}\",\"product_code\":\"${arr[1]}\",\"product_name_cn\":\"${arr[2]}\",\"product_cas\":\"${arr[3]}\","
            PRODUCT_LIST="${PRODUCT_LIST}\"molecular_formula\":\"${arr[4]}\",\"molecular_weight\":\"${arr[5]}\",\"HS_Code\":\"${arr[6]}\",\"category\":\"${arr[7]}\","
            PRODUCT_LIST="${PRODUCT_LIST}\"purpose\":\"${arr[8]}\""
            PRODUCT_LIST="${PRODUCT_LIST}}"            
        fi
    done

    PRODUCT_LIST="[${PRODUCT_LIST}]"

    SQL="update t_similarity_supplier set product_list='${PRODUCT_LIST}',product_count=${PRODUCT_COUNT} where supplier_code1='${SUPPLIER_CODE1}' and supplier_code2='${SUPPLIER_CODE2}';"

    SQL="${SQL}update t_similarity_supplier set product_list='${PRODUCT_LIST}',product_count=${PRODUCT_COUNT} where supplier_code1='${SUPPLIER_CODE2}' and supplier_code2='${SUPPLIER_CODE1}';"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`
    `echo "[$TIMESTAMP][DEBUG][SQL:${SQL}]" >> $LOG`  
}

function DoCalculateSupplierProducts() {
    SUPPLIER_CODE1=$1
    PRODUCT_CODE_ARRAY=$2
    SUPPLIER_CODE2=$3

    SQL="select product_code from v_product_supplier where supplier_code='$SUPPLIER_CODE2';"

    `echo "[$TIMESTAMP][DEBUG][SQL:${SQL}]" >> $LOG`
    `echo "[$TIMESTAMP][DEBUG][SUPPLIER_CODE1:${SUPPLIER_CODE1} PRODUCT_CODE_ARRAY:${PRODUCT_CODE_ARRAY} SUPPLIER_CODE2:${SUPPLIER_CODE2}]" >> $LOG`

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       `echo "[$TIMESTAMP][WARNNING][Has no product_code to doing for $SUPPLIER_CODE]" >> $LOG`
       return
    fi

    PRODUCT_CODES=""
    PRODUCT_COUNT=0
    for ITEM in ${VALUES}
    do
        for CODE in ${PRODUCT_CODE_ARRAY}
        do
            if [ "$ITEM" == "$CODE" ] ; then
                len=${#PRODUCT_CODES}

                if [ "$len" -eq "0" ]; then
                    PRODUCT_CODES="'${ITEM}'"
                else
                    PRODUCT_CODES="${PRODUCT_CODES},'${ITEM}'"
                fi    
                let PRODUCT_COUNT=${PRODUCT_COUNT}+1
            fi
        done
    done

    if [ "$PRODUCT_COUNT" -gt "0" ]; then
        `UpdateSupplierProducts ${SUPPLIER_CODE1} ${SUPPLIER_CODE2} ${PRODUCT_CODES} ${PRODUCT_COUNT}`
    fi
} 

function QuerySimilarityProduct() {
    PRODUCT_CODES=$1
    SUPPLIER_CODE=$2
    PRODUCT_CODE_ARRAY=$3

    SQL="select supplier_code from v_product_supplier where product_code in ($PRODUCT_CODES) and supplier_code <> '${SUPPLIER_CODE}';"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       `echo "[$TIMESTAMP][WARNNING][Has no supplier to doing for $PRODUCT_CODES]" >> $LOG`
       return
    fi

    SQL=""
    for ITEM in ${VALUES}
    do
       SQL="${SQL}insert into t_similarity_supplier(supplier_code1, supplier_code2, product_list, product_count, update_time, create_time) value('${SUPPLIER_CODE}', '${ITEM}', '', 0, ${TIMESTAMP}, ${TIMESTAMP}) ON DUPLICATE KEY UPDATE supplier_code1='${SUPPLIER_CODE}',supplier_code2='${ITEM}';"
       SQL="${SQL}insert into t_similarity_supplier(supplier_code1, supplier_code2, product_list, product_count, update_time, create_time) value('${ITEM}', '${SUPPLIER_CODE}', '', 0, ${TIMESTAMP}, ${TIMESTAMP}) ON DUPLICATE KEY UPDATE supplier_code1='${ITEM}',supplier_code2='${SUPPLIER_CODE}';"

       `DoCalculateSupplierProducts ${SUPPLIER_CODE} ${PRODUCT_CODE_ARRAY} ${ITEM}`      
    done

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`
    `echo "[$TIMESTAMP][DEBUG][SQL:${SQL}]" >> $LOG`
}

function QuerySimilaritySupplier() {
    SUPPLIER_CODE=$1

    SQL="select product_code from v_product_supplier where supplier_code='$SUPPLIER_CODE';"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       `echo "[$TIMESTAMP][WARNNING][Has no product_code to doing for $SUPPLIER_CODE]" >> $LOG`
       return
    fi

    PRODUCT_CODES=""

    for ITEM in ${VALUES}
    do
        len=${#PRODUCT_CODES}

        if [ "$len" -eq "0" ]; then
            PRODUCT_CODES="'${ITEM}'"
        else
            PRODUCT_CODES="${PRODUCT_CODES},'${ITEM}'"
        fi
    done

    `QuerySimilarityProduct ${PRODUCT_CODES} ${SUPPLIER_CODE} ${VALUES}`
}


function DoStat() {
    SQL="select supplier_code from t_supplier;"

    MYSQL="mysql -h $HOST -P $PORT -D $DATABASE -u $USER -p$PASSWORD --default-character-set=utf8 -A -N"

    VALUES=`$MYSQL -e "$SQL" --skip-column-names`

    if [ "$VALUES" == "" ] ; then
       `echo "[$TIMESTAMP][WARNNING][Has no supplier to doing]" >> $LOG`
       return
    fi

    for ITEM in ${VALUES}
    do
        `QuerySimilaritySupplier ${ITEM}`
    done
}

DoStat
