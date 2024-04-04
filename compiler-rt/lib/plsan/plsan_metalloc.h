#ifndef PLSAN_METALLOC_H
#define PLSAN_METALLOC_H

#define METALLOC_PAGESHIFT 12
#define METALLOC_PAGESIZE (1 << METALLOC_PAGESHIFT)

#define METALLOC_FIXEDSHIFT 3
#define METALLOC_FIXEDSIZE (1 << METALLOC_FIXEDSHIFT)

#define SYSTEM_PAGESIZE METALLOC_PAGESIZE

#define METADATASIZE 8
#define METADATA_ALIGN 8
//extern unsigned long pageTable[];
#define pageTable ((unsigned long*)(0x400000000000))
void page_table_init();
void* allocate_metadata(unsigned long size, unsigned long alignment);
void deallocate_metadata(void *ptr, unsigned long size, unsigned long alignment);
void set_metapagetable_entries(void *ptr, unsigned long size, void *metaptr, int alignment);
unsigned long get_metapagetable_entry(void *ptr);
void set_metadata(unsigned long ptr, unsigned long size);
void* get_metadata(unsigned long ptrInt);
#endif