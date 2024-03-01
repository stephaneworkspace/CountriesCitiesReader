//
//  cwrapper.h
//  
//
//  Created by Stéphane Bressani on 25.02.2024.
//

#ifdef __cplusplus
extern "C" {
#endif
    struct Record {
        int id;
        const char* cca2;
        const char* name;
        const char* name_fr;
        double lat;
        double lng;
    };
    struct Result {
        struct Record** records;
        int size;
        int codeError;
        const char* msgError;
    };
    struct Result cwrapperDb(const char* path);
    void cwrapperFreeRecord(struct Record* record);
    void cwrapperFreeResult(struct Result* result);
#ifdef __cplusplus
}
#endif
