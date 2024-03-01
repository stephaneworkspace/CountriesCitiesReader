//
//  cwrapper.c
//  
//
//  Created by Stéphane Bressani on 25.02.2024.
//
#import "include/cwrapper.h"
#import "shapefil.h"
#include <string>
#include <fstream>
#include <iostream>

/// Get data from ne_10m_populated_places
Result cwrapperDb(const char* path) {
    Result res;
    std::string basePath = std::string(path) + "ne_10m_populated_places";
    SHPHandle hSHP = SHPOpen(basePath.c_str(), "rb");
    DBFHandle hDBF = DBFOpen(basePath.c_str(), "rb");
    if (hSHP == nullptr || hDBF == nullptr) {
        Record** array = new Record*[0];
        res.records = array;
        res.size = 0;
        res.codeError = 100;
        res.msgError = strdup("00100 - Can't open ne_10m_populated_places");
        return res;
    }
    
    // Init
    int fieldCount;
    char fieldName[12];
    int width, dec;
    DBFFieldType fieldType;
    fieldCount = DBFGetFieldCount(hDBF);
    
    // Security
    int nameFieldIndex = DBFGetFieldIndex(hDBF, "NAME");
    if (nameFieldIndex == -1) {
        Record** array = new Record*[0];
        res.records = array;
        res.size = 0;
        res.codeError = 200;
        res.msgError = strdup("00200 - Can't find 'NAME'");
        return res;
    }
    int nameFraFieldIndex = DBFGetFieldIndex(hDBF, "NAME_FR");
    if (nameFraFieldIndex == -1) {
        Record** array = new Record*[0];
        res.records = array;
        res.size = 0;
        res.codeError = 200;
        res.msgError = strdup("00201 - Can't find 'NAME_FR'");
        return res;
    }
    int cca2FieldIndex = DBFGetFieldIndex(hDBF, "ISO_A2");
    if (cca2FieldIndex == -1) {
        Record** array = new Record*[0];
        res.records = array;
        res.size = 0;
        res.codeError = 201;
        res.msgError = strdup("00250 - Can't find 'ISO_A2'");
        return res;
    }
    
    // Define size of number of records
    int recordCount = DBFGetRecordCount(hDBF);
    int size = recordCount;
    Record** array = new Record*[size];
    for (int i = 0; i < size; ++i) {
        // Lat/Lng
        double* padfX = new double;
        double* padfY = new double;
        double lat = 0.0;
        double lng = 0.0;
        SHPObject* psShape = SHPReadObject(hSHP, i);
        if (psShape && psShape->nVertices > 0) {
            *padfX = psShape->padfX[0];
            *padfY = psShape->padfY[0];
            lat = *padfY;
            lng = *padfX;
        }
        delete padfX;
        delete padfY;
        SHPDestroyObject(psShape);
        
        // Record
        array[i] = new Record;
        array[i]->id = i;
        array[i]->cca2 = strdup(DBFReadStringAttribute(hDBF, i, cca2FieldIndex));
        array[i]->name = strdup(DBFReadStringAttribute(hDBF, i, nameFieldIndex));
        array[i]->name_fr = strdup(DBFReadStringAttribute(hDBF, i, nameFraFieldIndex));
        array[i]->lat = lat;
        array[i]->lng = lng;
    }
    res.records = array;
    res.size = size;
    res.codeError = 0;
    res.msgError = strdup("");
    return res;
}

/// Free ptr Record*
/// Only called by cwrapperFreeResult(Result* result)
void cwrapperFreeRecord(Record* record) {
    if (record != nullptr) {
        free((void*)record->name); // Frees the character
        delete record; // Frees the structure itself
    }
}

/// Free ptr Result* result
void cwrapperFreeResult(Result* result) {
    if (result != nullptr) {
        // Frees each Record in the array
        for (int i = 0; i < result->size; i++) {
            cwrapperFreeRecord(result->records[i]);
        }
        // Frees the pointer array
        delete[] result->records;

        // Frees the error message if dynamically allocated
        free((void*)result->msgError);

        // Reset the members of result to avoid use after free
        result->records = nullptr;
        result->size = 0;
        result->codeError = 0;
        result->msgError = nullptr;
    }
}
