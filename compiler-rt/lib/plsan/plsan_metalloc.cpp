#include <sys/mman.h>             // for mmap, memadvise
#include <string.h>               // for memchr
#include <stdlib.h>               // for getenv
#include <stdio.h>                // for printf
#include <plsan_metalloc.h>

#define unlikely(x)     __builtin_expect((x),0)

// Size of the pagetable (one entry per page)
#if FLAGS_METALLOC_FIXEDCOMPRESSION == false
#define PAGETABLESIZE (((unsigned long)1 << 48) / METALLOC_PAGESIZE)
#else
#define PAGETABLESIZE (((unsigned long)1 << 48) / ((METALLOC_FIXEDSIZE / FLAGS_METALLOC_METADATABYTES) * 16))
#endif
// Number of pagetable pages covered by each reftable entry
#define PTPAGESPERREFENTRY 1
// Size of the reftable (one entry per PAGESPERREFENTRY pages in the pagetable)
// #define REFTABLESIZE ((unsigned long)((PAGETABLESIZE << sizeof(unsigned long)) / METALLOC_PAGESIZE) * PTPAGESPERREFENTRY)
// Number of real pages covered by each reftable entry
// #define REALPAGESPERREFENTRY ((unsigned long)(METALLOC_USEDSIZE >> sizeof(unsigned long)) * PTPAGESPERREFENTRY)

//unsigned long pageTable[PAGETABLESIZE];
bool isPageTableAlloced = false;
//unsigned short refTable[REFTABLESIZE];

void page_table_init() {
    if (unlikely(!isPageTableAlloced)) {
        void *pageTableMap = mmap(pageTable, PAGETABLESIZE * sizeof(unsigned long), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
        if (pageTableMap == MAP_FAILED) {
            perror("Could not allocate pageTable");
            exit(-1);
        }
        isPageTableAlloced = true;
    }
}

bool is_metapagetable_alloced() {
    return isPageTableAlloced;
}

void* allocate_metadata(unsigned long size, unsigned long alignment) {
    /*if (unlikely(isPageTableAlloced == false))
        page_table_init();*/
    unsigned long pageAlignOffset = SYSTEM_PAGESIZE - 1;
    unsigned long pageAlignMask = ~((unsigned long)SYSTEM_PAGESIZE - 1);
    unsigned long metadataSize = (((size * METADATASIZE) >> alignment) + pageAlignOffset) & pageAlignMask;
    void *metadata = mmap(NULL, metadataSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (unlikely(metadata == MAP_FAILED)) {
        perror("Could not allocate metadata");
        exit(-1);
    }
    return metadata;
}

void deallocate_metadata(void *ptr, unsigned long size, unsigned long alignment) {
    unsigned long pageAlignOffset = SYSTEM_PAGESIZE - 1;
    unsigned long pageAlignMask = ~((unsigned long)SYSTEM_PAGESIZE - 1);
    unsigned long metadata = pageTable[((unsigned long)ptr) / METALLOC_PAGESIZE] >> 8;
    unsigned long metadataSize = (((size * METADATASIZE) >> alignment) + pageAlignOffset) & pageAlignMask;
    munmap((void*)metadata, metadataSize);
    return;
}

void set_metapagetable_entries(void *ptr, unsigned long size, void *metaptr, int alignment) {
    if (unlikely(isPageTableAlloced == false))
        page_table_init();
    if (unlikely(size % METALLOC_PAGESIZE != 0)) {
        printf("Meta-pagetable must be configured for ranges that are multiple of METALLOC_PAGESIZE %d", size);
        exit(-1);
    }
    // Get the page number
    unsigned long page = (unsigned long)ptr / METALLOC_PAGESIZE;
    // Get the page count
    unsigned long count = size / METALLOC_PAGESIZE;
    // For each page set the appropriate pagetable entry
    for (unsigned long i = 0; i < count; ++i) {
        // Compute the pointer towards the metadata
        // Shift the pointer by 8 positions to the left
        // Inject the alignment to the lower byte
        unsigned long metaOffset = (i * METALLOC_PAGESIZE >> alignment) * METADATASIZE;
        unsigned long pageMetaptr;
        if (metaptr == 0)
            pageMetaptr = 0;
        else 
            pageMetaptr = (unsigned long)metaptr + metaOffset;
        pageTable[page + i] = (pageMetaptr << 8) | (char)alignment;
    }
}

unsigned long get_metapagetable_entry(void *ptr) {
    if (unlikely(isPageTableAlloced == false))
        page_table_init();
    // Get the page number
    unsigned long page = (unsigned long)ptr / METALLOC_PAGESIZE;
    // Get table entry
    return pageTable[page];
}

void set_metadata(unsigned long ptr, unsigned long size) {
    unsigned long page_align_offset = METALLOC_PAGESIZE - 1;
    unsigned long page_align_mask = ~((unsigned long)METALLOC_PAGESIZE - 1);
    unsigned long aligned_start = ptr & page_align_mask;
    unsigned long aligned_size = ((size + ptr - aligned_start) + page_align_offset) & page_align_mask;
    void* metadata = allocate_metadata(aligned_size, METADATA_ALIGN);
    set_metapagetable_entries((void *)aligned_start, aligned_size, metadata, METADATA_ALIGN);
}

void* get_metadata(unsigned long ptrInt){
    unsigned long page = ptrInt / METALLOC_PAGESIZE;
    unsigned long entry = pageTable[page];          
    unsigned long alignment = entry & 0xFF;         
    char *metabase = (char*)(entry >> 8);           
    unsigned long pageOffset = ptrInt -             
                        (page * METALLOC_PAGESIZE); 
    char *metaptr = metabase + ((pageOffset >> alignment) * METADATASIZE);                      
    return metaptr;                  
}
