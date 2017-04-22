
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 00 70 10 80       	push   $0x80107000
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 25 42 00 00       	call   80104280 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 70 10 80       	push   $0x80107007
80100097:	50                   	push   %eax
80100098:	e8 d3 40 00 00       	call   80104170 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 b7 41 00 00       	call   801042a0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 19 43 00 00       	call   80104480 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 40 00 00       	call   801041b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 1f 00 00       	call   801020c0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 70 10 80       	push   $0x8010700e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 40 00 00       	call   80104250 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 f7 1e 00 00       	jmp    801020c0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 70 10 80       	push   $0x8010701f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 40 00 00       	call   80104250 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 40 00 00       	call   80104210 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 90 40 00 00       	call   801042a0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 1f 42 00 00       	jmp    80104480 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 70 10 80       	push   $0x80107026
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 ab 14 00 00       	call   80101730 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 0f 40 00 00       	call   801042a0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 2e 3b 00 00       	call   80103df0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 24             	mov    0x24(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 94 41 00 00       	call   80104480 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 5c 13 00 00       	call   80101650 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 35 41 00 00       	call   80104480 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 fd 12 00 00       	call   80101650 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 2d 70 10 80       	push   $0x8010702d
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 26 75 10 80 	movl   $0x80107526,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 b2 3f 00 00       	call   80104370 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 49 70 10 80       	push   $0x80107049
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 b1 57 00 00       	call   80105bd0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 f8 56 00 00       	call   80105bd0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 ec 56 00 00       	call   80105bd0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 e0 56 00 00       	call   80105bd0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 67 40 00 00       	call   80104580 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 a2 3f 00 00       	call   801044d0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 4d 70 10 80       	push   $0x8010704d
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 78 70 10 80 	movzbl -0x7fef8f88(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 1c 11 00 00       	call   80101730 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 80 3c 00 00       	call   801042a0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 34 3e 00 00       	call   80104480 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 fb 0f 00 00       	call   80101650 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 6e 3d 00 00       	call   80104480 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 60 70 10 80       	mov    $0x80107060,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 d3 3a 00 00       	call   801042a0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 67 70 10 80       	push   $0x80107067
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 98 3a 00 00       	call   801042a0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 13 3c 00 00       	call   80104480 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 a5 36 00 00       	call   80103fa0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 14 37 00 00       	jmp    80104090 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 70 70 10 80       	push   $0x80107070
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 cb 38 00 00       	call   80104280 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 a1 28 00 00       	call   80103280 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 96 18 00 00       	call   80102280 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 af 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 74 14 00 00       	call   80101e80 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 9f 01 00 00    	je     80100bb6 <exec+0x1c6>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 2e 0c 00 00       	call   80101650 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 dd 0e 00 00       	call   80101910 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 34             	cmp    $0x34,%eax
80100a39:	74 25                	je     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 7c 0e 00 00       	call   801018c0 <iunlockput>
    end_op();
80100a44:	e8 d7 21 00 00       	call   80102c20 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 1f 5f 00 00       	call   80106990 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a82:	00 
80100a83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a90:	00 00 00 
80100a93:	0f 84 c5 00 00 00    	je     80100b5e <exec+0x16e>
80100a99:	31 ff                	xor    %edi,%edi
80100a9b:	eb 18                	jmp    80100ab5 <exec+0xc5>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
80100aa0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	83 c6 20             	add    $0x20,%esi
80100aad:	39 f8                	cmp    %edi,%eax
80100aaf:	0f 8e a9 00 00 00    	jle    80100b5e <exec+0x16e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ab5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100abb:	6a 20                	push   $0x20
80100abd:	56                   	push   %esi
80100abe:	50                   	push   %eax
80100abf:	53                   	push   %ebx
80100ac0:	e8 4b 0e 00 00       	call   80101910 <readi>
80100ac5:	83 c4 10             	add    $0x10,%esp
80100ac8:	83 f8 20             	cmp    $0x20,%eax
80100acb:	75 7b                	jne    80100b48 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad4:	75 ca                	jne    80100aa0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae2:	72 64                	jb     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aea:	72 5c                	jb     80100b48 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aec:	83 ec 04             	sub    $0x4,%esp
80100aef:	50                   	push   %eax
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 4f 61 00 00       	call   80106c50 <allocuvm>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0c:	74 3a                	je     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b14:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b19:	75 2d                	jne    80100b48 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b24:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b2a:	53                   	push   %ebx
80100b2b:	50                   	push   %eax
80100b2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b32:	e8 59 60 00 00       	call   80106b90 <loaduvm>
80100b37:	83 c4 20             	add    $0x20,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 89 5e ff ff ff    	jns    80100aa0 <exec+0xb0>
80100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b51:	e8 2a 62 00 00       	call   80106d80 <freevm>
80100b56:	83 c4 10             	add    $0x10,%esp
80100b59:	e9 dd fe ff ff       	jmp    80100a3b <exec+0x4b>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	53                   	push   %ebx
80100b62:	e8 59 0d 00 00       	call   801018c0 <iunlockput>
  end_op();
80100b67:	e8 b4 20 00 00       	call   80102c20 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b6c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b72:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b75:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b85:	52                   	push   %edx
80100b86:	50                   	push   %eax
80100b87:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8d:	e8 be 60 00 00       	call   80106c50 <allocuvm>
80100b92:	83 c4 10             	add    $0x10,%esp
80100b95:	85 c0                	test   %eax,%eax
80100b97:	89 c6                	mov    %eax,%esi
80100b99:	75 2a                	jne    80100bc5 <exec+0x1d5>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b9b:	83 ec 0c             	sub    $0xc,%esp
80100b9e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba4:	e8 d7 61 00 00       	call   80106d80 <freevm>
80100ba9:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb1:	e9 9b fe ff ff       	jmp    80100a51 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bb6:	e8 65 20 00 00       	call   80102c20 <end_op>
    return -1;
80100bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc0:	e9 8c fe ff ff       	jmp    80100a51 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bcb:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bce:	31 ff                	xor    %edi,%edi
80100bd0:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd9:	e8 22 62 00 00       	call   80106e00 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bde:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bea:	8b 00                	mov    (%eax),%eax
80100bec:	85 c0                	test   %eax,%eax
80100bee:	74 6d                	je     80100c5d <exec+0x26d>
80100bf0:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bf6:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bfc:	eb 07                	jmp    80100c05 <exec+0x215>
80100bfe:	66 90                	xchg   %ax,%ax
    if(argc >= MAXARG)
80100c00:	83 ff 20             	cmp    $0x20,%edi
80100c03:	74 96                	je     80100b9b <exec+0x1ab>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c05:	83 ec 0c             	sub    $0xc,%esp
80100c08:	50                   	push   %eax
80100c09:	e8 02 3b 00 00       	call   80104710 <strlen>
80100c0e:	f7 d0                	not    %eax
80100c10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c15:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c1c:	e8 ef 3a 00 00       	call   80104710 <strlen>
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	50                   	push   %eax
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c2b:	53                   	push   %ebx
80100c2c:	56                   	push   %esi
80100c2d:	e8 2e 63 00 00       	call   80106f60 <copyout>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	85 c0                	test   %eax,%eax
80100c37:	0f 88 5e ff ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c47:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c53:	85 c0                	test   %eax,%eax
80100c55:	75 a9                	jne    80100c00 <exec+0x210>
80100c57:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c64:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c6d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c78:	ff ff ff 
  ustack[1] = argc;
80100c7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c83:	83 c0 0c             	add    $0xc,%eax
80100c86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c88:	50                   	push   %eax
80100c89:	52                   	push   %edx
80100c8a:	53                   	push   %ebx
80100c8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c97:	e8 c4 62 00 00       	call   80106f60 <copyout>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	85 c0                	test   %eax,%eax
80100ca1:	0f 88 f4 fe ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80100caa:	0f b6 10             	movzbl (%eax),%edx
80100cad:	84 d2                	test   %dl,%dl
80100caf:	74 19                	je     80100cca <exec+0x2da>
80100cb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cb4:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cb7:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cba:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cbd:	0f 44 c8             	cmove  %eax,%ecx
80100cc0:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc3:	84 d2                	test   %dl,%dl
80100cc5:	75 f0                	jne    80100cb7 <exec+0x2c7>
80100cc7:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cca:	50                   	push   %eax
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	6a 10                	push   $0x10
80100cd3:	ff 75 08             	pushl  0x8(%ebp)
80100cd6:	83 c0 6c             	add    $0x6c,%eax
80100cd9:	50                   	push   %eax
80100cda:	e8 f1 39 00 00       	call   801046d0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce5:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ceb:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cee:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cf0:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100cf3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf9:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cff:	8b 50 18             	mov    0x18(%eax),%edx
80100d02:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d05:	8b 50 18             	mov    0x18(%eax),%edx
80100d08:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0b:	89 04 24             	mov    %eax,(%esp)
80100d0e:	e8 2d 5d 00 00       	call   80106a40 <switchuvm>
  freevm(oldpgdir);
80100d13:	89 3c 24             	mov    %edi,(%esp)
80100d16:	e8 65 60 00 00       	call   80106d80 <freevm>
  return 0;
80100d1b:	83 c4 10             	add    $0x10,%esp
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 2c fd ff ff       	jmp    80100a51 <exec+0x61>
80100d25:	66 90                	xchg   %ax,%ax
80100d27:	66 90                	xchg   %ax,%ax
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 89 70 10 80       	push   $0x80107089
80100d3b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d40:	e8 3b 35 00 00       	call   80104280 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d61:	e8 3a 35 00 00       	call   801042a0 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 ea 36 00 00       	call   80104480 <release>
      return f;
80100d96:	89 d8                	mov    %ebx,%eax
80100d98:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
80100da3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100da8:	e8 d3 36 00 00       	call   80104480 <release>
  return 0;
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	31 c0                	xor    %eax,%eax
}
80100db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db5:	c9                   	leave  
80100db6:	c3                   	ret    
80100db7:	89 f6                	mov    %esi,%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dcf:	e8 cc 34 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dec:	e8 8f 36 00 00       	call   80104480 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 90 70 10 80       	push   $0x80107090
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e21:	e8 7a 34 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100e26:	8b 47 04             	mov    0x4(%edi),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 47 04             	mov    %eax,0x4(%edi)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4c:	e9 2f 36 00 00       	jmp    80104480 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e58:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e5c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e61:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e64:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e70:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e78:	e8 03 36 00 00       	call   80104480 <release>

  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 fb 01             	cmp    $0x1,%ebx
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e85:	83 fb 02             	cmp    $0x2,%ebx
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 aa 25 00 00       	call   80103450 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 fb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 c0 08 00 00       	call   80101780 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eca:	e9 51 1d 00 00       	jmp    80102c20 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 98 70 10 80       	push   $0x80107098
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 56 07 00 00       	call   80101650 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 d9 09 00 00       	call   801018e0 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 20 08 00 00       	call   80101730 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 f1 06 00 00       	call   80101650 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 a4 09 00 00       	call   80101910 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 ad 07 00 00       	call   80101730 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f86:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f9d:	e9 7e 26 00 00       	jmp    80103620 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fad:	eb d9                	jmp    80100f88 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 a2 70 10 80       	push   $0x801070a2
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d8 00 00 00    	jne    801010ce <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 ff                	xor    %edi,%edi
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 17 07 00 00       	call   80101730 <iunlock>
      end_op();
80101019:	e8 02 1c 00 00       	call   80102c20 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 d8                	cmp    %ebx,%eax
80101026:	0f 85 95 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010102c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101046:	e8 65 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 fa 05 00 00       	call   80101650 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 a8 09 00 00       	call   80101a10 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 b3 06 00 00       	call   80101730 <iunlock>
      end_op();
8010107d:	e8 9e 1b 00 00       	call   80102c20 <end_op>

      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010108f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101094:	5b                   	pop    %ebx
80101095:	5e                   	pop    %esi
80101096:	5f                   	pop    %edi
80101097:	5d                   	pop    %ebp
80101098:	c3                   	ret    
80101099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 46 0c             	mov    0xc(%esi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 2f 24 00 00       	jmp    801034f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	83 ec 0c             	sub    $0xc,%esp
801010c4:	68 ab 70 10 80       	push   $0x801070ab
801010c9:	e8 a2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ce:	83 ec 0c             	sub    $0xc,%esp
801010d1:	68 b1 70 10 80       	push   $0x801070b1
801010d6:	e8 95 f2 ff ff       	call   80100370 <panic>
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 85 00 00 00    	je     8010117f <balloc+0x9f>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 b5 ef ff ff       	call   801000d0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2d                	jmp    8010115a <balloc+0x7a>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
80101132:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101149:	85 d7                	test   %edx,%edi
8010114b:	74 43                	je     80101190 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114d:	83 c0 01             	add    $0x1,%eax
80101150:	83 c6 01             	add    $0x1,%esi
80101153:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101158:	74 05                	je     8010115f <balloc+0x7f>
8010115a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010115d:	72 d1                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 75 e4             	pushl  -0x1c(%ebp)
80101165:	e8 76 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101177:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010117d:	77 82                	ja     80101101 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 bb 70 10 80       	push   $0x801070bb
80101187:	e8 e4 f1 ff ff       	call   80100370 <panic>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	09 fa                	or     %edi,%edx
80101192:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101195:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 ee 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 36 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 1b ef ff ff       	call   801000d0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 06 33 00 00       	call   801044d0 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 be 1b 00 00       	call   80102d90 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101205:	68 00 0a 11 80       	push   $0x80110a00
8010120a:	e8 91 30 00 00       	call   801042a0 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 1b                	jmp    80101232 <iget+0x42>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101220:	85 f6                	test   %esi,%esi
80101222:	74 44                	je     80101268 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101224:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010122a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101230:	74 4e                	je     80101280 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101232:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101235:	85 c9                	test   %ecx,%ecx
80101237:	7e e7                	jle    80101220 <iget+0x30>
80101239:	39 3b                	cmp    %edi,(%ebx)
8010123b:	75 e3                	jne    80101220 <iget+0x30>
8010123d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101240:	75 de                	jne    80101220 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101245:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101248:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010124f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101252:	e8 29 32 00 00       	call   80104480 <release>
      return ip;
80101257:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	89 f0                	mov    %esi,%eax
8010125f:	5b                   	pop    %ebx
80101260:	5e                   	pop    %esi
80101261:	5f                   	pop    %edi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    
80101264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101279:	75 b7                	jne    80101232 <iget+0x42>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 2d                	je     801012b1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 dc 31 00 00       	call   80104480 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 d1 70 10 80       	push   $0x801070d1
801012b9:	e8 b2 f0 ff ff       	call   80100370 <panic>
801012be:	66 90                	xchg   %ax,%ax

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 76                	je     80101350 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	0f 87 83 00 00 00    	ja     80101377 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012fa:	85 c0                	test   %eax,%eax
801012fc:	74 6a                	je     80101368 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fe:	83 ec 08             	sub    $0x8,%esp
80101301:	50                   	push   %eax
80101302:	ff 36                	pushl  (%esi)
80101304:	e8 c7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101309:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010130d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101310:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101312:	8b 1a                	mov    (%edx),%ebx
80101314:	85 db                	test   %ebx,%ebx
80101316:	75 1d                	jne    80101335 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101318:	8b 06                	mov    (%esi),%eax
8010131a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010131d:	e8 be fd ff ff       	call   801010e0 <balloc>
80101322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101325:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101328:	89 c3                	mov    %eax,%ebx
8010132a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 5e 1a 00 00       	call   80102d90 <log_write>
80101332:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101335:	83 ec 0c             	sub    $0xc,%esp
80101338:	57                   	push   %edi
80101339:	e8 a2 ee ff ff       	call   801001e0 <brelse>
8010133e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101344:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101346:	5b                   	pop    %ebx
80101347:	5e                   	pop    %esi
80101348:	5f                   	pop    %edi
80101349:	5d                   	pop    %ebp
8010134a:	c3                   	ret    
8010134b:	90                   	nop
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 06                	mov    (%esi),%eax
80101352:	e8 89 fd ff ff       	call   801010e0 <balloc>
80101357:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 06                	mov    (%esi),%eax
8010136a:	e8 71 fd ff ff       	call   801010e0 <balloc>
8010136f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101375:	eb 87                	jmp    801012fe <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	83 ec 0c             	sub    $0xc,%esp
8010137a:	68 e1 70 10 80       	push   $0x801070e1
8010137f:	e8 ec ef ff ff       	call   80100370 <panic>
80101384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010138a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	6a 01                	push   $0x1
8010139d:	ff 75 08             	pushl  0x8(%ebp)
801013a0:	e8 2b ed ff ff       	call   801000d0 <bread>
801013a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013aa:	83 c4 0c             	add    $0xc,%esp
801013ad:	6a 1c                	push   $0x1c
801013af:	50                   	push   %eax
801013b0:	56                   	push   %esi
801013b1:	e8 ca 31 00 00       	call   80104580 <memmove>
  brelse(bp);
801013b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013b9:	83 c4 10             	add    $0x10,%esp
}
801013bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c2:	e9 19 ee ff ff       	jmp    801001e0 <brelse>
801013c7:	89 f6                	mov    %esi,%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	89 d3                	mov    %edx,%ebx
801013d7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013d9:	83 ec 08             	sub    $0x8,%esp
801013dc:	68 e0 09 11 80       	push   $0x801109e0
801013e1:	50                   	push   %eax
801013e2:	e8 a9 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013e7:	58                   	pop    %eax
801013e8:	5a                   	pop    %edx
801013e9:	89 da                	mov    %ebx,%edx
801013eb:	c1 ea 0c             	shr    $0xc,%edx
801013ee:	03 15 f8 09 11 80    	add    0x801109f8,%edx
801013f4:	52                   	push   %edx
801013f5:	56                   	push   %esi
801013f6:	e8 d5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101403:	ba 01 00 00 00       	mov    $0x1,%edx
80101408:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140b:	c1 fb 03             	sar    $0x3,%ebx
8010140e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101411:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101413:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101418:	85 d1                	test   %edx,%ecx
8010141a:	74 27                	je     80101443 <bfree+0x73>
8010141c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010141e:	f7 d2                	not    %edx
80101420:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101422:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101425:	21 d0                	and    %edx,%eax
80101427:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010142b:	56                   	push   %esi
8010142c:	e8 5f 19 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 a7 ed ff ff       	call   801001e0 <brelse>
}
80101439:	83 c4 10             	add    $0x10,%esp
8010143c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101443:	83 ec 0c             	sub    $0xc,%esp
80101446:	68 f4 70 10 80       	push   $0x801070f4
8010144b:	e8 20 ef ff ff       	call   80100370 <panic>

80101450 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101459:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010145c:	68 07 71 10 80       	push   $0x80107107
80101461:	68 00 0a 11 80       	push   $0x80110a00
80101466:	e8 15 2e 00 00       	call   80104280 <initlock>
8010146b:	83 c4 10             	add    $0x10,%esp
8010146e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	68 0e 71 10 80       	push   $0x8010710e
80101478:	53                   	push   %ebx
80101479:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147f:	e8 ec 2c 00 00       	call   80104170 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010148d:	75 e1                	jne    80101470 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010148f:	83 ec 08             	sub    $0x8,%esp
80101492:	68 e0 09 11 80       	push   $0x801109e0
80101497:	ff 75 08             	pushl  0x8(%ebp)
8010149a:	e8 f1 fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010149f:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014a5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014ab:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014b1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014b7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014bd:	ff 35 e4 09 11 80    	pushl  0x801109e4
801014c3:	ff 35 e0 09 11 80    	pushl  0x801109e0
801014c9:	68 64 71 10 80       	push   $0x80107164
801014ce:	e8 8d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014d3:	83 c4 30             	add    $0x30,%esp
801014d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d9:	c9                   	leave  
801014da:	c3                   	ret    
801014db:	90                   	nop
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e9:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f3:	8b 75 08             	mov    0x8(%ebp),%esi
801014f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	0f 86 91 00 00 00    	jbe    80101590 <ialloc+0xb0>
801014ff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101504:	eb 21                	jmp    80101527 <ialloc+0x47>
80101506:	8d 76 00             	lea    0x0(%esi),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101510:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101513:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101516:	57                   	push   %edi
80101517:	e8 c4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 c4 10             	add    $0x10,%esp
8010151f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101525:	76 69                	jbe    80101590 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101527:	89 d8                	mov    %ebx,%eax
80101529:	83 ec 08             	sub    $0x8,%esp
8010152c:	c1 e8 03             	shr    $0x3,%eax
8010152f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101535:	50                   	push   %eax
80101536:	56                   	push   %esi
80101537:	e8 94 eb ff ff       	call   801000d0 <bread>
8010153c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010153e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101540:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101543:	83 e0 07             	and    $0x7,%eax
80101546:	c1 e0 06             	shl    $0x6,%eax
80101549:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010154d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101551:	75 bd                	jne    80101510 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101553:	83 ec 04             	sub    $0x4,%esp
80101556:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101559:	6a 40                	push   $0x40
8010155b:	6a 00                	push   $0x0
8010155d:	51                   	push   %ecx
8010155e:	e8 6d 2f 00 00       	call   801044d0 <memset>
      dip->type = type;
80101563:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101567:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010156a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010156d:	89 3c 24             	mov    %edi,(%esp)
80101570:	e8 1b 18 00 00       	call   80102d90 <log_write>
      brelse(bp);
80101575:	89 3c 24             	mov    %edi,(%esp)
80101578:	e8 63 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010157d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101580:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101583:	89 da                	mov    %ebx,%edx
80101585:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101587:	5b                   	pop    %ebx
80101588:	5e                   	pop    %esi
80101589:	5f                   	pop    %edi
8010158a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010158b:	e9 60 fc ff ff       	jmp    801011f0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101590:	83 ec 0c             	sub    $0xc,%esp
80101593:	68 14 71 10 80       	push   $0x80107114
80101598:	e8 d3 ed ff ff       	call   80100370 <panic>
8010159d:	8d 76 00             	lea    0x0(%esi),%esi

801015a0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	56                   	push   %esi
801015a4:	53                   	push   %ebx
801015a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ae:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b1:	c1 e8 03             	shr    $0x3,%eax
801015b4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015ba:	50                   	push   %eax
801015bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015be:	e8 0d eb ff ff       	call   801000d0 <bread>
801015c3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015c5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015c8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015cc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015cf:	83 e0 07             	and    $0x7,%eax
801015d2:	c1 e0 06             	shl    $0x6,%eax
801015d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015e0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fd:	6a 34                	push   $0x34
801015ff:	53                   	push   %ebx
80101600:	50                   	push   %eax
80101601:	e8 7a 2f 00 00       	call   80104580 <memmove>
  log_write(bp);
80101606:	89 34 24             	mov    %esi,(%esp)
80101609:	e8 82 17 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010160e:	89 75 08             	mov    %esi,0x8(%ebp)
80101611:	83 c4 10             	add    $0x10,%esp
}
80101614:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101617:	5b                   	pop    %ebx
80101618:	5e                   	pop    %esi
80101619:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010161a:	e9 c1 eb ff ff       	jmp    801001e0 <brelse>
8010161f:	90                   	nop

80101620 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	53                   	push   %ebx
80101624:	83 ec 10             	sub    $0x10,%esp
80101627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010162a:	68 00 0a 11 80       	push   $0x80110a00
8010162f:	e8 6c 2c 00 00       	call   801042a0 <acquire>
  ip->ref++;
80101634:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101638:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010163f:	e8 3c 2e 00 00       	call   80104480 <release>
  return ip;
}
80101644:	89 d8                	mov    %ebx,%eax
80101646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101649:	c9                   	leave  
8010164a:	c3                   	ret    
8010164b:	90                   	nop
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101658:	85 db                	test   %ebx,%ebx
8010165a:	0f 84 b4 00 00 00    	je     80101714 <ilock+0xc4>
80101660:	8b 43 08             	mov    0x8(%ebx),%eax
80101663:	85 c0                	test   %eax,%eax
80101665:	0f 8e a9 00 00 00    	jle    80101714 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010166b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010166e:	83 ec 0c             	sub    $0xc,%esp
80101671:	50                   	push   %eax
80101672:	e8 39 2b 00 00       	call   801041b0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101677:	83 c4 10             	add    $0x10,%esp
8010167a:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010167e:	74 10                	je     80101690 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101680:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
80101686:	c3                   	ret    
80101687:	89 f6                	mov    %esi,%esi
80101689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101690:	8b 43 04             	mov    0x4(%ebx),%eax
80101693:	83 ec 08             	sub    $0x8,%esp
80101696:	c1 e8 03             	shr    $0x3,%eax
80101699:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010169f:	50                   	push   %eax
801016a0:	ff 33                	pushl  (%ebx)
801016a2:	e8 29 ea ff ff       	call   801000d0 <bread>
801016a7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ac:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016af:	83 e0 07             	and    $0x7,%eax
801016b2:	c1 e0 06             	shl    $0x6,%eax
801016b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016b9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016db:	8b 50 fc             	mov    -0x4(%eax),%edx
801016de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016e1:	6a 34                	push   $0x34
801016e3:	50                   	push   %eax
801016e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016e7:	50                   	push   %eax
801016e8:	e8 93 2e 00 00       	call   80104580 <memmove>
    brelse(bp);
801016ed:	89 34 24             	mov    %esi,(%esp)
801016f0:	e8 eb ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
801016f5:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
801016f9:	83 c4 10             	add    $0x10,%esp
801016fc:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101701:	0f 85 79 ff ff ff    	jne    80101680 <ilock+0x30>
      panic("ilock: no type");
80101707:	83 ec 0c             	sub    $0xc,%esp
8010170a:	68 2c 71 10 80       	push   $0x8010712c
8010170f:	e8 5c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101714:	83 ec 0c             	sub    $0xc,%esp
80101717:	68 26 71 10 80       	push   $0x80107126
8010171c:	e8 4f ec ff ff       	call   80100370 <panic>
80101721:	eb 0d                	jmp    80101730 <iunlock>
80101723:	90                   	nop
80101724:	90                   	nop
80101725:	90                   	nop
80101726:	90                   	nop
80101727:	90                   	nop
80101728:	90                   	nop
80101729:	90                   	nop
8010172a:	90                   	nop
8010172b:	90                   	nop
8010172c:	90                   	nop
8010172d:	90                   	nop
8010172e:	90                   	nop
8010172f:	90                   	nop

80101730 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101738:	85 db                	test   %ebx,%ebx
8010173a:	74 28                	je     80101764 <iunlock+0x34>
8010173c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010173f:	83 ec 0c             	sub    $0xc,%esp
80101742:	56                   	push   %esi
80101743:	e8 08 2b 00 00       	call   80104250 <holdingsleep>
80101748:	83 c4 10             	add    $0x10,%esp
8010174b:	85 c0                	test   %eax,%eax
8010174d:	74 15                	je     80101764 <iunlock+0x34>
8010174f:	8b 43 08             	mov    0x8(%ebx),%eax
80101752:	85 c0                	test   %eax,%eax
80101754:	7e 0e                	jle    80101764 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101756:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175c:	5b                   	pop    %ebx
8010175d:	5e                   	pop    %esi
8010175e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010175f:	e9 ac 2a 00 00       	jmp    80104210 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101764:	83 ec 0c             	sub    $0xc,%esp
80101767:	68 3b 71 10 80       	push   $0x8010713b
8010176c:	e8 ff eb ff ff       	call   80100370 <panic>
80101771:	eb 0d                	jmp    80101780 <iput>
80101773:	90                   	nop
80101774:	90                   	nop
80101775:	90                   	nop
80101776:	90                   	nop
80101777:	90                   	nop
80101778:	90                   	nop
80101779:	90                   	nop
8010177a:	90                   	nop
8010177b:	90                   	nop
8010177c:	90                   	nop
8010177d:	90                   	nop
8010177e:	90                   	nop
8010177f:	90                   	nop

80101780 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 28             	sub    $0x28,%esp
80101789:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010178c:	68 00 0a 11 80       	push   $0x80110a00
80101791:	e8 0a 2b 00 00       	call   801042a0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101796:	8b 46 08             	mov    0x8(%esi),%eax
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	83 f8 01             	cmp    $0x1,%eax
8010179f:	74 1f                	je     801017c0 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017a1:	83 e8 01             	sub    $0x1,%eax
801017a4:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017a7:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017b1:	5b                   	pop    %ebx
801017b2:	5e                   	pop    %esi
801017b3:	5f                   	pop    %edi
801017b4:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017b5:	e9 c6 2c 00 00       	jmp    80104480 <release>
801017ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017c0:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
801017c4:	74 db                	je     801017a1 <iput+0x21>
801017c6:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017cb:	75 d4                	jne    801017a1 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
801017cd:	83 ec 0c             	sub    $0xc,%esp
801017d0:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017d3:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
801017d9:	68 00 0a 11 80       	push   $0x80110a00
801017de:	e8 9d 2c 00 00       	call   80104480 <release>
801017e3:	83 c4 10             	add    $0x10,%esp
801017e6:	eb 0f                	jmp    801017f7 <iput+0x77>
801017e8:	90                   	nop
801017e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017f0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017f3:	39 fb                	cmp    %edi,%ebx
801017f5:	74 19                	je     80101810 <iput+0x90>
    if(ip->addrs[i]){
801017f7:	8b 13                	mov    (%ebx),%edx
801017f9:	85 d2                	test   %edx,%edx
801017fb:	74 f3                	je     801017f0 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
801017fd:	8b 06                	mov    (%esi),%eax
801017ff:	e8 cc fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010180a:	eb e4                	jmp    801017f0 <iput+0x70>
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101810:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101816:	85 c0                	test   %eax,%eax
80101818:	75 46                	jne    80101860 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010181a:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010181d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101824:	56                   	push   %esi
80101825:	e8 76 fd ff ff       	call   801015a0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
8010182a:	31 c0                	xor    %eax,%eax
8010182c:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101830:	89 34 24             	mov    %esi,(%esp)
80101833:	e8 68 fd ff ff       	call   801015a0 <iupdate>
    acquire(&icache.lock);
80101838:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010183f:	e8 5c 2a 00 00       	call   801042a0 <acquire>
    ip->flags = 0;
80101844:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010184b:	8b 46 08             	mov    0x8(%esi),%eax
8010184e:	83 c4 10             	add    $0x10,%esp
80101851:	e9 4b ff ff ff       	jmp    801017a1 <iput+0x21>
80101856:	8d 76 00             	lea    0x0(%esi),%esi
80101859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101860:	83 ec 08             	sub    $0x8,%esp
80101863:	50                   	push   %eax
80101864:	ff 36                	pushl  (%esi)
80101866:	e8 65 e8 ff ff       	call   801000d0 <bread>
8010186b:	83 c4 10             	add    $0x10,%esp
8010186e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101871:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101874:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x107>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101883:	39 df                	cmp    %ebx,%edi
80101885:	74 0f                	je     80101896 <iput+0x116>
      if(a[j])
80101887:	8b 13                	mov    (%ebx),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x100>
        bfree(ip->dev, a[j]);
8010188d:	8b 06                	mov    (%esi),%eax
8010188f:	e8 3c fb ff ff       	call   801013d0 <bfree>
80101894:	eb ea                	jmp    80101880 <iput+0x100>
    }
    brelse(bp);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	ff 75 e4             	pushl  -0x1c(%ebp)
8010189c:	e8 3f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018a1:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018a7:	8b 06                	mov    (%esi),%eax
801018a9:	e8 22 fb ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018ae:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018b5:	00 00 00 
801018b8:	83 c4 10             	add    $0x10,%esp
801018bb:	e9 5a ff ff ff       	jmp    8010181a <iput+0x9a>

801018c0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	53                   	push   %ebx
801018c4:	83 ec 10             	sub    $0x10,%esp
801018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ca:	53                   	push   %ebx
801018cb:	e8 60 fe ff ff       	call   80101730 <iunlock>
  iput(ip);
801018d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018d3:	83 c4 10             	add    $0x10,%esp
}
801018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018d9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018da:	e9 a1 fe ff ff       	jmp    80101780 <iput>
801018df:	90                   	nop

801018e0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	8b 55 08             	mov    0x8(%ebp),%edx
801018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018e9:	8b 0a                	mov    (%edx),%ecx
801018eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801018f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018f4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801018f8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018fb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801018ff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101903:	8b 52 58             	mov    0x58(%edx),%edx
80101906:	89 50 10             	mov    %edx,0x10(%eax)
}
80101909:	5d                   	pop    %ebp
8010190a:	c3                   	ret    
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 1c             	sub    $0x1c,%esp
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010191f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101922:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101927:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010192a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010192d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101930:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101933:	0f 84 a7 00 00 00    	je     801019e0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101939:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010193c:	8b 40 58             	mov    0x58(%eax),%eax
8010193f:	39 f0                	cmp    %esi,%eax
80101941:	0f 82 c1 00 00 00    	jb     80101a08 <readi+0xf8>
80101947:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010194a:	89 fa                	mov    %edi,%edx
8010194c:	01 f2                	add    %esi,%edx
8010194e:	0f 82 b4 00 00 00    	jb     80101a08 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101954:	89 c1                	mov    %eax,%ecx
80101956:	29 f1                	sub    %esi,%ecx
80101958:	39 d0                	cmp    %edx,%eax
8010195a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010195d:	31 ff                	xor    %edi,%edi
8010195f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101961:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101964:	74 6d                	je     801019d3 <readi+0xc3>
80101966:	8d 76 00             	lea    0x0(%esi),%esi
80101969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101970:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101973:	89 f2                	mov    %esi,%edx
80101975:	c1 ea 09             	shr    $0x9,%edx
80101978:	89 d8                	mov    %ebx,%eax
8010197a:	e8 41 f9 ff ff       	call   801012c0 <bmap>
8010197f:	83 ec 08             	sub    $0x8,%esp
80101982:	50                   	push   %eax
80101983:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101985:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010198a:	e8 41 e7 ff ff       	call   801000d0 <bread>
8010198f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101994:	89 f1                	mov    %esi,%ecx
80101996:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010199c:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
8010199f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019a2:	29 cb                	sub    %ecx,%ebx
801019a4:	29 f8                	sub    %edi,%eax
801019a6:	39 c3                	cmp    %eax,%ebx
801019a8:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019ab:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019af:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b0:	01 df                	add    %ebx,%edi
801019b2:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019b4:	50                   	push   %eax
801019b5:	ff 75 e0             	pushl  -0x20(%ebp)
801019b8:	e8 c3 2b 00 00       	call   80104580 <memmove>
    brelse(bp);
801019bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019c0:	89 14 24             	mov    %edx,(%esp)
801019c3:	e8 18 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019cb:	83 c4 10             	add    $0x10,%esp
801019ce:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019d1:	77 9d                	ja     80101970 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d9:	5b                   	pop    %ebx
801019da:	5e                   	pop    %esi
801019db:	5f                   	pop    %edi
801019dc:	5d                   	pop    %ebp
801019dd:	c3                   	ret    
801019de:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019e0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019e4:	66 83 f8 09          	cmp    $0x9,%ax
801019e8:	77 1e                	ja     80101a08 <readi+0xf8>
801019ea:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
801019f1:	85 c0                	test   %eax,%eax
801019f3:	74 13                	je     80101a08 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019f5:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
801019f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019fb:	5b                   	pop    %ebx
801019fc:	5e                   	pop    %esi
801019fd:	5f                   	pop    %edi
801019fe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019ff:	ff e0                	jmp    *%eax
80101a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a0d:	eb c7                	jmp    801019d6 <readi+0xc6>
80101a0f:	90                   	nop

80101a10 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 1c             	sub    $0x1c,%esp
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a33:	0f 84 b7 00 00 00    	je     80101af0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a3f:	0f 82 eb 00 00 00    	jb     80101b30 <writei+0x120>
80101a45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a48:	89 f8                	mov    %edi,%eax
80101a4a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a4c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a51:	0f 87 d9 00 00 00    	ja     80101b30 <writei+0x120>
80101a57:	39 c6                	cmp    %eax,%esi
80101a59:	0f 87 d1 00 00 00    	ja     80101b30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a5f:	85 ff                	test   %edi,%edi
80101a61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a68:	74 78                	je     80101ae2 <writei+0xd2>
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a73:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a75:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a7a:	c1 ea 09             	shr    $0x9,%edx
80101a7d:	89 f8                	mov    %edi,%eax
80101a7f:	e8 3c f8 ff ff       	call   801012c0 <bmap>
80101a84:	83 ec 08             	sub    $0x8,%esp
80101a87:	50                   	push   %eax
80101a88:	ff 37                	pushl  (%edi)
80101a8a:	e8 41 e6 ff ff       	call   801000d0 <bread>
80101a8f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a94:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101a97:	89 f1                	mov    %esi,%ecx
80101a99:	83 c4 0c             	add    $0xc,%esp
80101a9c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101aa2:	29 cb                	sub    %ecx,%ebx
80101aa4:	39 c3                	cmp    %eax,%ebx
80101aa6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101aa9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aad:	53                   	push   %ebx
80101aae:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ab3:	50                   	push   %eax
80101ab4:	e8 c7 2a 00 00       	call   80104580 <memmove>
    log_write(bp);
80101ab9:	89 3c 24             	mov    %edi,(%esp)
80101abc:	e8 cf 12 00 00       	call   80102d90 <log_write>
    brelse(bp);
80101ac1:	89 3c 24             	mov    %edi,(%esp)
80101ac4:	e8 17 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101acc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ad5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ad8:	77 96                	ja     80101a70 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101ada:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101add:	3b 70 58             	cmp    0x58(%eax),%esi
80101ae0:	77 36                	ja     80101b18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5f                   	pop    %edi
80101aeb:	5d                   	pop    %ebp
80101aec:	c3                   	ret    
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 36                	ja     80101b30 <writei+0x120>
80101afa:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 2b                	je     80101b30 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0b:	5b                   	pop    %ebx
80101b0c:	5e                   	pop    %esi
80101b0d:	5f                   	pop    %edi
80101b0e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b0f:	ff e0                	jmp    *%eax
80101b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b1b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b21:	50                   	push   %eax
80101b22:	e8 79 fa ff ff       	call   801015a0 <iupdate>
80101b27:	83 c4 10             	add    $0x10,%esp
80101b2a:	eb b6                	jmp    80101ae2 <writei+0xd2>
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b35:	eb ae                	jmp    80101ae5 <writei+0xd5>
80101b37:	89 f6                	mov    %esi,%esi
80101b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b46:	6a 0e                	push   $0xe
80101b48:	ff 75 0c             	pushl  0xc(%ebp)
80101b4b:	ff 75 08             	pushl  0x8(%ebp)
80101b4e:	e8 ad 2a 00 00       	call   80104600 <strncmp>
}
80101b53:	c9                   	leave  
80101b54:	c3                   	ret    
80101b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 1c             	sub    $0x1c,%esp
80101b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b71:	0f 85 80 00 00 00    	jne    80101bf7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b77:	8b 53 58             	mov    0x58(%ebx),%edx
80101b7a:	31 ff                	xor    %edi,%edi
80101b7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b7f:	85 d2                	test   %edx,%edx
80101b81:	75 0d                	jne    80101b90 <dirlookup+0x30>
80101b83:	eb 5b                	jmp    80101be0 <dirlookup+0x80>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
80101b88:	83 c7 10             	add    $0x10,%edi
80101b8b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b8e:	76 50                	jbe    80101be0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b90:	6a 10                	push   $0x10
80101b92:	57                   	push   %edi
80101b93:	56                   	push   %esi
80101b94:	53                   	push   %ebx
80101b95:	e8 76 fd ff ff       	call   80101910 <readi>
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	83 f8 10             	cmp    $0x10,%eax
80101ba0:	75 48                	jne    80101bea <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101ba2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ba7:	74 df                	je     80101b88 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101ba9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bac:	83 ec 04             	sub    $0x4,%esp
80101baf:	6a 0e                	push   $0xe
80101bb1:	50                   	push   %eax
80101bb2:	ff 75 0c             	pushl  0xc(%ebp)
80101bb5:	e8 46 2a 00 00       	call   80104600 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	85 c0                	test   %eax,%eax
80101bbf:	75 c7                	jne    80101b88 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bc1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bc4:	85 c0                	test   %eax,%eax
80101bc6:	74 05                	je     80101bcd <dirlookup+0x6d>
        *poff = off;
80101bc8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bcb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bcd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101bd1:	8b 03                	mov    (%ebx),%eax
80101bd3:	e8 18 f6 ff ff       	call   801011f0 <iget>
    }
  }

  return 0;
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
80101bdf:	c3                   	ret    
80101be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101be3:	31 c0                	xor    %eax,%eax
}
80101be5:	5b                   	pop    %ebx
80101be6:	5e                   	pop    %esi
80101be7:	5f                   	pop    %edi
80101be8:	5d                   	pop    %ebp
80101be9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	68 55 71 10 80       	push   $0x80107155
80101bf2:	e8 79 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	68 43 71 10 80       	push   $0x80107143
80101bff:	e8 6c e7 ff ff       	call   80100370 <panic>
80101c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	89 cf                	mov    %ecx,%edi
80101c18:	89 c3                	mov    %eax,%ebx
80101c1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c1d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c23:	0f 84 53 01 00 00    	je     80101d7c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c2f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c32:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c35:	68 00 0a 11 80       	push   $0x80110a00
80101c3a:	e8 61 26 00 00       	call   801042a0 <acquire>
  ip->ref++;
80101c3f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c43:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c4a:	e8 31 28 00 00       	call   80104480 <release>
80101c4f:	83 c4 10             	add    $0x10,%esp
80101c52:	eb 07                	jmp    80101c5b <namex+0x4b>
80101c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c58:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c5b:	0f b6 03             	movzbl (%ebx),%eax
80101c5e:	3c 2f                	cmp    $0x2f,%al
80101c60:	74 f6                	je     80101c58 <namex+0x48>
    path++;
  if(*path == 0)
80101c62:	84 c0                	test   %al,%al
80101c64:	0f 84 e3 00 00 00    	je     80101d4d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c6a:	0f b6 03             	movzbl (%ebx),%eax
80101c6d:	89 da                	mov    %ebx,%edx
80101c6f:	84 c0                	test   %al,%al
80101c71:	0f 84 ac 00 00 00    	je     80101d23 <namex+0x113>
80101c77:	3c 2f                	cmp    $0x2f,%al
80101c79:	75 09                	jne    80101c84 <namex+0x74>
80101c7b:	e9 a3 00 00 00       	jmp    80101d23 <namex+0x113>
80101c80:	84 c0                	test   %al,%al
80101c82:	74 0a                	je     80101c8e <namex+0x7e>
    path++;
80101c84:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c87:	0f b6 02             	movzbl (%edx),%eax
80101c8a:	3c 2f                	cmp    $0x2f,%al
80101c8c:	75 f2                	jne    80101c80 <namex+0x70>
80101c8e:	89 d1                	mov    %edx,%ecx
80101c90:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101c92:	83 f9 0d             	cmp    $0xd,%ecx
80101c95:	0f 8e 8d 00 00 00    	jle    80101d28 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101c9b:	83 ec 04             	sub    $0x4,%esp
80101c9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ca1:	6a 0e                	push   $0xe
80101ca3:	53                   	push   %ebx
80101ca4:	57                   	push   %edi
80101ca5:	e8 d6 28 00 00       	call   80104580 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cad:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cb0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cb2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cb5:	75 11                	jne    80101cc8 <namex+0xb8>
80101cb7:	89 f6                	mov    %esi,%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cc3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cc6:	74 f8                	je     80101cc0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cc8:	83 ec 0c             	sub    $0xc,%esp
80101ccb:	56                   	push   %esi
80101ccc:	e8 7f f9 ff ff       	call   80101650 <ilock>
    if(ip->type != T_DIR){
80101cd1:	83 c4 10             	add    $0x10,%esp
80101cd4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101cd9:	0f 85 7f 00 00 00    	jne    80101d5e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ce2:	85 d2                	test   %edx,%edx
80101ce4:	74 09                	je     80101cef <namex+0xdf>
80101ce6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ce9:	0f 84 a3 00 00 00    	je     80101d92 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cef:	83 ec 04             	sub    $0x4,%esp
80101cf2:	6a 00                	push   $0x0
80101cf4:	57                   	push   %edi
80101cf5:	56                   	push   %esi
80101cf6:	e8 65 fe ff ff       	call   80101b60 <dirlookup>
80101cfb:	83 c4 10             	add    $0x10,%esp
80101cfe:	85 c0                	test   %eax,%eax
80101d00:	74 5c                	je     80101d5e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d02:	83 ec 0c             	sub    $0xc,%esp
80101d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d08:	56                   	push   %esi
80101d09:	e8 22 fa ff ff       	call   80101730 <iunlock>
  iput(ip);
80101d0e:	89 34 24             	mov    %esi,(%esp)
80101d11:	e8 6a fa ff ff       	call   80101780 <iput>
80101d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d19:	83 c4 10             	add    $0x10,%esp
80101d1c:	89 c6                	mov    %eax,%esi
80101d1e:	e9 38 ff ff ff       	jmp    80101c5b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d23:	31 c9                	xor    %ecx,%ecx
80101d25:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d28:	83 ec 04             	sub    $0x4,%esp
80101d2b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d2e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d31:	51                   	push   %ecx
80101d32:	53                   	push   %ebx
80101d33:	57                   	push   %edi
80101d34:	e8 47 28 00 00       	call   80104580 <memmove>
    name[len] = 0;
80101d39:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d3f:	83 c4 10             	add    $0x10,%esp
80101d42:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d46:	89 d3                	mov    %edx,%ebx
80101d48:	e9 65 ff ff ff       	jmp    80101cb2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d50:	85 c0                	test   %eax,%eax
80101d52:	75 54                	jne    80101da8 <namex+0x198>
80101d54:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d59:	5b                   	pop    %ebx
80101d5a:	5e                   	pop    %esi
80101d5b:	5f                   	pop    %edi
80101d5c:	5d                   	pop    %ebp
80101d5d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d5e:	83 ec 0c             	sub    $0xc,%esp
80101d61:	56                   	push   %esi
80101d62:	e8 c9 f9 ff ff       	call   80101730 <iunlock>
  iput(ip);
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 11 fa ff ff       	call   80101780 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d6f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d75:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d7c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d81:	b8 01 00 00 00       	mov    $0x1,%eax
80101d86:	e8 65 f4 ff ff       	call   801011f0 <iget>
80101d8b:	89 c6                	mov    %eax,%esi
80101d8d:	e9 c9 fe ff ff       	jmp    80101c5b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	56                   	push   %esi
80101d96:	e8 95 f9 ff ff       	call   80101730 <iunlock>
      return ip;
80101d9b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101da1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da3:	5b                   	pop    %ebx
80101da4:	5e                   	pop    %esi
80101da5:	5f                   	pop    %edi
80101da6:	5d                   	pop    %ebp
80101da7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	56                   	push   %esi
80101dac:	e8 cf f9 ff ff       	call   80101780 <iput>
    return 0;
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	31 c0                	xor    %eax,%eax
80101db6:	eb 9e                	jmp    80101d56 <namex+0x146>
80101db8:	90                   	nop
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 20             	sub    $0x20,%esp
80101dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dcc:	6a 00                	push   $0x0
80101dce:	ff 75 0c             	pushl  0xc(%ebp)
80101dd1:	53                   	push   %ebx
80101dd2:	e8 89 fd ff ff       	call   80101b60 <dirlookup>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	85 c0                	test   %eax,%eax
80101ddc:	75 67                	jne    80101e45 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101de1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101de4:	85 ff                	test   %edi,%edi
80101de6:	74 29                	je     80101e11 <dirlink+0x51>
80101de8:	31 ff                	xor    %edi,%edi
80101dea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ded:	eb 09                	jmp    80101df8 <dirlink+0x38>
80101def:	90                   	nop
80101df0:	83 c7 10             	add    $0x10,%edi
80101df3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101df6:	76 19                	jbe    80101e11 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df8:	6a 10                	push   $0x10
80101dfa:	57                   	push   %edi
80101dfb:	56                   	push   %esi
80101dfc:	53                   	push   %ebx
80101dfd:	e8 0e fb ff ff       	call   80101910 <readi>
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	83 f8 10             	cmp    $0x10,%eax
80101e08:	75 4e                	jne    80101e58 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e0f:	75 df                	jne    80101df0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e14:	83 ec 04             	sub    $0x4,%esp
80101e17:	6a 0e                	push   $0xe
80101e19:	ff 75 0c             	pushl  0xc(%ebp)
80101e1c:	50                   	push   %eax
80101e1d:	e8 4e 28 00 00       	call   80104670 <strncpy>
  de.inum = inum;
80101e22:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e25:	6a 10                	push   $0x10
80101e27:	57                   	push   %edi
80101e28:	56                   	push   %esi
80101e29:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e2a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e2e:	e8 dd fb ff ff       	call   80101a10 <writei>
80101e33:	83 c4 20             	add    $0x20,%esp
80101e36:	83 f8 10             	cmp    $0x10,%eax
80101e39:	75 2a                	jne    80101e65 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e3b:	31 c0                	xor    %eax,%eax
}
80101e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e40:	5b                   	pop    %ebx
80101e41:	5e                   	pop    %esi
80101e42:	5f                   	pop    %edi
80101e43:	5d                   	pop    %ebp
80101e44:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e45:	83 ec 0c             	sub    $0xc,%esp
80101e48:	50                   	push   %eax
80101e49:	e8 32 f9 ff ff       	call   80101780 <iput>
    return -1;
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e56:	eb e5                	jmp    80101e3d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e58:	83 ec 0c             	sub    $0xc,%esp
80101e5b:	68 55 71 10 80       	push   $0x80107155
80101e60:	e8 0b e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e65:	83 ec 0c             	sub    $0xc,%esp
80101e68:	68 1e 77 10 80       	push   $0x8010771e
80101e6d:	e8 fe e4 ff ff       	call   80100370 <panic>
80101e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e80 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e81:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e83:	89 e5                	mov    %esp,%ebp
80101e85:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e88:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e8e:	e8 7d fd ff ff       	call   80101c10 <namex>
}
80101e93:	c9                   	leave  
80101e94:	c3                   	ret    
80101e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ea0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ea1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ea6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eae:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eaf:	e9 5c fd ff ff       	jmp    80101c10 <namex>
80101eb4:	66 90                	xchg   %ax,%ax
80101eb6:	66 90                	xchg   %ax,%ax
80101eb8:	66 90                	xchg   %ax,%ax
80101eba:	66 90                	xchg   %ax,%ax
80101ebc:	66 90                	xchg   %ax,%ax
80101ebe:	66 90                	xchg   %ax,%ax

80101ec0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ec0:	55                   	push   %ebp
  if(b == 0)
80101ec1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	56                   	push   %esi
80101ec6:	53                   	push   %ebx
  if(b == 0)
80101ec7:	0f 84 ad 00 00 00    	je     80101f7a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101ecd:	8b 58 08             	mov    0x8(%eax),%ebx
80101ed0:	89 c1                	mov    %eax,%ecx
80101ed2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ed8:	0f 87 8f 00 00 00    	ja     80101f6d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ede:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ee8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ee9:	83 e0 c0             	and    $0xffffffc0,%eax
80101eec:	3c 40                	cmp    $0x40,%al
80101eee:	75 f8                	jne    80101ee8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ef0:	31 f6                	xor    %esi,%esi
80101ef2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ef7:	89 f0                	mov    %esi,%eax
80101ef9:	ee                   	out    %al,(%dx)
80101efa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101eff:	b8 01 00 00 00       	mov    $0x1,%eax
80101f04:	ee                   	out    %al,(%dx)
80101f05:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f0a:	89 d8                	mov    %ebx,%eax
80101f0c:	ee                   	out    %al,(%dx)
80101f0d:	89 d8                	mov    %ebx,%eax
80101f0f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f14:	c1 f8 08             	sar    $0x8,%eax
80101f17:	ee                   	out    %al,(%dx)
80101f18:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f1d:	89 f0                	mov    %esi,%eax
80101f1f:	ee                   	out    %al,(%dx)
80101f20:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f24:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f29:	83 e0 01             	and    $0x1,%eax
80101f2c:	c1 e0 04             	shl    $0x4,%eax
80101f2f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f32:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f33:	f6 01 04             	testb  $0x4,(%ecx)
80101f36:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f3b:	75 13                	jne    80101f50 <idestart+0x90>
80101f3d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f42:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f46:	5b                   	pop    %ebx
80101f47:	5e                   	pop    %esi
80101f48:	5d                   	pop    %ebp
80101f49:	c3                   	ret    
80101f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f50:	b8 30 00 00 00       	mov    $0x30,%eax
80101f55:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f56:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f5b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f5e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f63:	fc                   	cld    
80101f64:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f69:	5b                   	pop    %ebx
80101f6a:	5e                   	pop    %esi
80101f6b:	5d                   	pop    %ebp
80101f6c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f6d:	83 ec 0c             	sub    $0xc,%esp
80101f70:	68 c0 71 10 80       	push   $0x801071c0
80101f75:	e8 f6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f7a:	83 ec 0c             	sub    $0xc,%esp
80101f7d:	68 b7 71 10 80       	push   $0x801071b7
80101f82:	e8 e9 e3 ff ff       	call   80100370 <panic>
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101f96:	68 d2 71 10 80       	push   $0x801071d2
80101f9b:	68 80 a5 10 80       	push   $0x8010a580
80101fa0:	e8 db 22 00 00       	call   80104280 <initlock>
  picenable(IRQ_IDE);
80101fa5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fac:	e8 cf 12 00 00       	call   80103280 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fb1:	58                   	pop    %eax
80101fb2:	a1 80 2d 11 80       	mov    0x80112d80,%eax
80101fb7:	5a                   	pop    %edx
80101fb8:	83 e8 01             	sub    $0x1,%eax
80101fbb:	50                   	push   %eax
80101fbc:	6a 0e                	push   $0xe
80101fbe:	e8 bd 02 00 00       	call   80102280 <ioapicenable>
80101fc3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fc6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fcb:	90                   	nop
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fd1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fd4:	3c 40                	cmp    $0x40,%al
80101fd6:	75 f8                	jne    80101fd0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fdd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101fe2:	ee                   	out    %al,(%dx)
80101fe3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fe8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fed:	eb 06                	jmp    80101ff5 <ideinit+0x65>
80101fef:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101ff0:	83 e9 01             	sub    $0x1,%ecx
80101ff3:	74 0f                	je     80102004 <ideinit+0x74>
80101ff5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101ff6:	84 c0                	test   %al,%al
80101ff8:	74 f6                	je     80101ff0 <ideinit+0x60>
      havedisk1 = 1;
80101ffa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102001:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102004:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102009:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010200e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010200f:	c9                   	leave  
80102010:	c3                   	ret    
80102011:	eb 0d                	jmp    80102020 <ideintr>
80102013:	90                   	nop
80102014:	90                   	nop
80102015:	90                   	nop
80102016:	90                   	nop
80102017:	90                   	nop
80102018:	90                   	nop
80102019:	90                   	nop
8010201a:	90                   	nop
8010201b:	90                   	nop
8010201c:	90                   	nop
8010201d:	90                   	nop
8010201e:	90                   	nop
8010201f:	90                   	nop

80102020 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
80102026:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102029:	68 80 a5 10 80       	push   $0x8010a580
8010202e:	e8 6d 22 00 00       	call   801042a0 <acquire>
  if((b = idequeue) == 0){
80102033:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102039:	83 c4 10             	add    $0x10,%esp
8010203c:	85 db                	test   %ebx,%ebx
8010203e:	74 34                	je     80102074 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102040:	8b 43 58             	mov    0x58(%ebx),%eax
80102043:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102048:	8b 33                	mov    (%ebx),%esi
8010204a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102050:	74 3e                	je     80102090 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102052:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102055:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102058:	83 ce 02             	or     $0x2,%esi
8010205b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010205d:	53                   	push   %ebx
8010205e:	e8 3d 1f 00 00       	call   80103fa0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102063:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	85 c0                	test   %eax,%eax
8010206d:	74 05                	je     80102074 <ideintr+0x54>
    idestart(idequeue);
8010206f:	e8 4c fe ff ff       	call   80101ec0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102074:	83 ec 0c             	sub    $0xc,%esp
80102077:	68 80 a5 10 80       	push   $0x8010a580
8010207c:	e8 ff 23 00 00       	call   80104480 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102084:	5b                   	pop    %ebx
80102085:	5e                   	pop    %esi
80102086:	5f                   	pop    %edi
80102087:	5d                   	pop    %ebp
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102090:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102095:	8d 76 00             	lea    0x0(%esi),%esi
80102098:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102099:	89 c1                	mov    %eax,%ecx
8010209b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010209e:	80 f9 40             	cmp    $0x40,%cl
801020a1:	75 f5                	jne    80102098 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020a3:	a8 21                	test   $0x21,%al
801020a5:	75 ab                	jne    80102052 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020a7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020aa:	b9 80 00 00 00       	mov    $0x80,%ecx
801020af:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020b4:	fc                   	cld    
801020b5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	eb 97                	jmp    80102052 <ideintr+0x32>
801020bb:	90                   	nop
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	53                   	push   %ebx
801020c4:	83 ec 10             	sub    $0x10,%esp
801020c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801020cd:	50                   	push   %eax
801020ce:	e8 7d 21 00 00       	call   80104250 <holdingsleep>
801020d3:	83 c4 10             	add    $0x10,%esp
801020d6:	85 c0                	test   %eax,%eax
801020d8:	0f 84 ad 00 00 00    	je     8010218b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020de:	8b 03                	mov    (%ebx),%eax
801020e0:	83 e0 06             	and    $0x6,%eax
801020e3:	83 f8 02             	cmp    $0x2,%eax
801020e6:	0f 84 b9 00 00 00    	je     801021a5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020ec:	8b 53 04             	mov    0x4(%ebx),%edx
801020ef:	85 d2                	test   %edx,%edx
801020f1:	74 0d                	je     80102100 <iderw+0x40>
801020f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020f8:	85 c0                	test   %eax,%eax
801020fa:	0f 84 98 00 00 00    	je     80102198 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	68 80 a5 10 80       	push   $0x8010a580
80102108:	e8 93 21 00 00       	call   801042a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010210d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102113:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102116:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010211d:	85 d2                	test   %edx,%edx
8010211f:	75 09                	jne    8010212a <iderw+0x6a>
80102121:	eb 58                	jmp    8010217b <iderw+0xbb>
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102128:	89 c2                	mov    %eax,%edx
8010212a:	8b 42 58             	mov    0x58(%edx),%eax
8010212d:	85 c0                	test   %eax,%eax
8010212f:	75 f7                	jne    80102128 <iderw+0x68>
80102131:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102134:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102136:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010213c:	74 44                	je     80102182 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	74 23                	je     8010216b <iderw+0xab>
80102148:	90                   	nop
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102150:	83 ec 08             	sub    $0x8,%esp
80102153:	68 80 a5 10 80       	push   $0x8010a580
80102158:	53                   	push   %ebx
80102159:	e8 92 1c 00 00       	call   80103df0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	83 e0 06             	and    $0x6,%eax
80102166:	83 f8 02             	cmp    $0x2,%eax
80102169:	75 e5                	jne    80102150 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010216b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102175:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102176:	e9 05 23 00 00       	jmp    80104480 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102180:	eb b2                	jmp    80102134 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102182:	89 d8                	mov    %ebx,%eax
80102184:	e8 37 fd ff ff       	call   80101ec0 <idestart>
80102189:	eb b3                	jmp    8010213e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010218b:	83 ec 0c             	sub    $0xc,%esp
8010218e:	68 d6 71 10 80       	push   $0x801071d6
80102193:	e8 d8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 01 72 10 80       	push   $0x80107201
801021a0:	e8 cb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ec 71 10 80       	push   $0x801071ec
801021ad:	e8 be e1 ff ff       	call   80100370 <panic>
801021b2:	66 90                	xchg   %ax,%ax
801021b4:	66 90                	xchg   %ax,%ax
801021b6:	66 90                	xchg   %ax,%ax
801021b8:	66 90                	xchg   %ax,%ax
801021ba:	66 90                	xchg   %ax,%ax
801021bc:	66 90                	xchg   %ax,%ax
801021be:	66 90                	xchg   %ax,%ax

801021c0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021c0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021c5:	85 c0                	test   %eax,%eax
801021c7:	0f 84 a8 00 00 00    	je     80102275 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021cd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021ce:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801021d5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021d8:	89 e5                	mov    %esp,%ebp
801021da:	56                   	push   %esi
801021db:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021dc:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021e3:	00 00 00 
  return ioapic->data;
801021e6:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801021ec:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021f5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021fb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102202:	89 f0                	mov    %esi,%eax
80102204:	c1 e8 10             	shr    $0x10,%eax
80102207:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010220a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220d:	c1 e8 18             	shr    $0x18,%eax
80102210:	39 d0                	cmp    %edx,%eax
80102212:	74 16                	je     8010222a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 20 72 10 80       	push   $0x80107220
8010221c:	e8 3f e4 ff ff       	call   80100660 <cprintf>
80102221:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102227:	83 c4 10             	add    $0x10,%esp
8010222a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010222d:	ba 10 00 00 00       	mov    $0x10,%edx
80102232:	b8 20 00 00 00       	mov    $0x20,%eax
80102237:	89 f6                	mov    %esi,%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102240:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102242:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102248:	89 c3                	mov    %eax,%ebx
8010224a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102250:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102253:	89 59 10             	mov    %ebx,0x10(%ecx)
80102256:	8d 5a 01             	lea    0x1(%edx),%ebx
80102259:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010225c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010225e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102260:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102266:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226d:	75 d1                	jne    80102240 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010226f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	f3 c3                	repz ret 
80102277:	89 f6                	mov    %esi,%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102280:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102286:	55                   	push   %ebp
80102287:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102289:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010228b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010228e:	74 2b                	je     801022bb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102290:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102296:	8d 50 20             	lea    0x20(%eax),%edx
80102299:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010229d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010229f:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ae:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b0:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022b8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022bb:	5d                   	pop    %ebp
801022bc:	c3                   	ret    
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 04             	sub    $0x4,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022d0:	75 70                	jne    80102342 <kfree+0x82>
801022d2:	81 fb 28 76 11 80    	cmp    $0x80117628,%ebx
801022d8:	72 68                	jb     80102342 <kfree+0x82>
801022da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022e5:	77 5b                	ja     80102342 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022e7:	83 ec 04             	sub    $0x4,%esp
801022ea:	68 00 10 00 00       	push   $0x1000
801022ef:	6a 01                	push   $0x1
801022f1:	53                   	push   %ebx
801022f2:	e8 d9 21 00 00       	call   801044d0 <memset>

  if(kmem.use_lock)
801022f7:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	85 d2                	test   %edx,%edx
80102302:	75 2c                	jne    80102330 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102304:	a1 98 26 11 80       	mov    0x80112698,%eax
80102309:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010230b:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102310:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102316:	85 c0                	test   %eax,%eax
80102318:	75 06                	jne    80102320 <kfree+0x60>
    release(&kmem.lock);
}
8010231a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010231d:	c9                   	leave  
8010231e:	c3                   	ret    
8010231f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102320:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010232b:	e9 50 21 00 00       	jmp    80104480 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 60 26 11 80       	push   $0x80112660
80102338:	e8 63 1f 00 00       	call   801042a0 <acquire>
8010233d:	83 c4 10             	add    $0x10,%esp
80102340:	eb c2                	jmp    80102304 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102342:	83 ec 0c             	sub    $0xc,%esp
80102345:	68 52 72 10 80       	push   $0x80107252
8010234a:	e8 21 e0 ff ff       	call   80100370 <panic>
8010234f:	90                   	nop

80102350 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102358:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010235b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102361:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102367:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010236d:	39 de                	cmp    %ebx,%esi
8010236f:	72 23                	jb     80102394 <freerange+0x44>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102378:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010237e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102381:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102387:	50                   	push   %eax
80102388:	e8 33 ff ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	39 f3                	cmp    %esi,%ebx
80102392:	76 e4                	jbe    80102378 <freerange+0x28>
    kfree(p);
}
80102394:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102397:	5b                   	pop    %ebx
80102398:	5e                   	pop    %esi
80102399:	5d                   	pop    %ebp
8010239a:	c3                   	ret    
8010239b:	90                   	nop
8010239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023a0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023a8:	83 ec 08             	sub    $0x8,%esp
801023ab:	68 58 72 10 80       	push   $0x80107258
801023b0:	68 60 26 11 80       	push   $0x80112660
801023b5:	e8 c6 1e 00 00       	call   80104280 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023c0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023c7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dc:	39 de                	cmp    %ebx,%esi
801023de:	72 1c                	jb     801023fc <kinit1+0x5c>
    kfree(p);
801023e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023e6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ef:	50                   	push   %eax
801023f0:	e8 cb fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f5:	83 c4 10             	add    $0x10,%esp
801023f8:	39 de                	cmp    %ebx,%esi
801023fa:	73 e4                	jae    801023e0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023ff:	5b                   	pop    %ebx
80102400:	5e                   	pop    %esi
80102401:	5d                   	pop    %ebp
80102402:	c3                   	ret    
80102403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102421:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242d:	39 de                	cmp    %ebx,%esi
8010242f:	72 23                	jb     80102454 <kinit2+0x44>
80102431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102438:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010243e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102447:	50                   	push   %eax
80102448:	e8 73 fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	39 de                	cmp    %ebx,%esi
80102452:	73 e4                	jae    80102438 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102454:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010245b:	00 00 00 
}
8010245e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
80102474:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102477:	a1 94 26 11 80       	mov    0x80112694,%eax
8010247c:	85 c0                	test   %eax,%eax
8010247e:	75 30                	jne    801024b0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102480:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102486:	85 db                	test   %ebx,%ebx
80102488:	74 1c                	je     801024a6 <kalloc+0x36>
    kmem.freelist = r->next;
8010248a:	8b 13                	mov    (%ebx),%edx
8010248c:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
80102492:	85 c0                	test   %eax,%eax
80102494:	74 10                	je     801024a6 <kalloc+0x36>
    release(&kmem.lock);
80102496:	83 ec 0c             	sub    $0xc,%esp
80102499:	68 60 26 11 80       	push   $0x80112660
8010249e:	e8 dd 1f 00 00       	call   80104480 <release>
801024a3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024a6:	89 d8                	mov    %ebx,%eax
801024a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    
801024ad:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024b0:	83 ec 0c             	sub    $0xc,%esp
801024b3:	68 60 26 11 80       	push   $0x80112660
801024b8:	e8 e3 1d 00 00       	call   801042a0 <acquire>
  r = kmem.freelist;
801024bd:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	a1 94 26 11 80       	mov    0x80112694,%eax
801024cb:	85 db                	test   %ebx,%ebx
801024cd:	75 bb                	jne    8010248a <kalloc+0x1a>
801024cf:	eb c1                	jmp    80102492 <kalloc+0x22>
801024d1:	66 90                	xchg   %ax,%ax
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024e0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e1:	ba 64 00 00 00       	mov    $0x64,%edx
801024e6:	89 e5                	mov    %esp,%ebp
801024e8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024e9:	a8 01                	test   $0x1,%al
801024eb:	0f 84 af 00 00 00    	je     801025a0 <kbdgetc+0xc0>
801024f1:	ba 60 00 00 00       	mov    $0x60,%edx
801024f6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024f7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024fa:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102500:	74 7e                	je     80102580 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102502:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102504:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010250a:	79 24                	jns    80102530 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010250c:	f6 c1 40             	test   $0x40,%cl
8010250f:	75 05                	jne    80102516 <kbdgetc+0x36>
80102511:	89 c2                	mov    %eax,%edx
80102513:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102516:	0f b6 82 80 73 10 80 	movzbl -0x7fef8c80(%edx),%eax
8010251d:	83 c8 40             	or     $0x40,%eax
80102520:	0f b6 c0             	movzbl %al,%eax
80102523:	f7 d0                	not    %eax
80102525:	21 c8                	and    %ecx,%eax
80102527:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010252c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010252e:	5d                   	pop    %ebp
8010252f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102530:	f6 c1 40             	test   $0x40,%cl
80102533:	74 09                	je     8010253e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102535:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102538:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010253b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010253e:	0f b6 82 80 73 10 80 	movzbl -0x7fef8c80(%edx),%eax
80102545:	09 c1                	or     %eax,%ecx
80102547:	0f b6 82 80 72 10 80 	movzbl -0x7fef8d80(%edx),%eax
8010254e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102550:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102552:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102558:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010255b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010255e:	8b 04 85 60 72 10 80 	mov    -0x7fef8da0(,%eax,4),%eax
80102565:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102569:	74 c3                	je     8010252e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010256b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256e:	83 fa 19             	cmp    $0x19,%edx
80102571:	77 1d                	ja     80102590 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102573:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102576:	5d                   	pop    %ebp
80102577:	c3                   	ret    
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102580:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102582:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	90                   	nop
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102590:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102593:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102596:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102597:	83 f9 19             	cmp    $0x19,%ecx
8010259a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a5:	5d                   	pop    %ebp
801025a6:	c3                   	ret    
801025a7:	89 f6                	mov    %esi,%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025b0 <kbdintr>:

void
kbdintr(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025b6:	68 e0 24 10 80       	push   $0x801024e0
801025bb:	e8 30 e2 ff ff       	call   801007f0 <consoleintr>
}
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	c9                   	leave  
801025c4:	c3                   	ret    
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801025d0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801025d5:	55                   	push   %ebp
801025d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025d8:	85 c0                	test   %eax,%eax
801025da:	0f 84 c8 00 00 00    	je     801026a8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ea:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102601:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102604:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102607:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010260e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102611:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102614:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010261b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010261e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102621:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102628:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010262e:	8b 50 30             	mov    0x30(%eax),%edx
80102631:	c1 ea 10             	shr    $0x10,%edx
80102634:	80 fa 03             	cmp    $0x3,%dl
80102637:	77 77                	ja     801026b0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102639:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102640:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102643:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102646:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010264d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102650:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102653:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102660:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102667:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102681:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102690:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102696:	80 e6 10             	and    $0x10,%dh
80102699:	75 f5                	jne    80102690 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026a8:	5d                   	pop    %ebp
801026a9:	c3                   	ret    
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
801026bd:	e9 77 ff ff ff       	jmp    80102639 <lapicinit+0x69>
801026c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801026d5:	9c                   	pushf  
801026d6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801026d7:	f6 c4 02             	test   $0x2,%ah
801026da:	74 12                	je     801026ee <cpunum+0x1e>
    static int n;
    if(n++ == 0)
801026dc:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801026e1:	8d 50 01             	lea    0x1(%eax),%edx
801026e4:	85 c0                	test   %eax,%eax
801026e6:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801026ec:	74 4d                	je     8010273b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801026ee:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026f3:	85 c0                	test   %eax,%eax
801026f5:	74 60                	je     80102757 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801026f7:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801026fa:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102700:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102703:	85 f6                	test   %esi,%esi
80102705:	7e 59                	jle    80102760 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102707:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
8010270e:	39 c3                	cmp    %eax,%ebx
80102710:	74 45                	je     80102757 <cpunum+0x87>
80102712:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
80102717:	31 c0                	xor    %eax,%eax
80102719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102720:	83 c0 01             	add    $0x1,%eax
80102723:	39 f0                	cmp    %esi,%eax
80102725:	74 39                	je     80102760 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102727:	0f b6 0a             	movzbl (%edx),%ecx
8010272a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102730:	39 cb                	cmp    %ecx,%ebx
80102732:	75 ec                	jne    80102720 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102734:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102737:	5b                   	pop    %ebx
80102738:	5e                   	pop    %esi
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010273b:	83 ec 08             	sub    $0x8,%esp
8010273e:	ff 75 04             	pushl  0x4(%ebp)
80102741:	68 80 74 10 80       	push   $0x80107480
80102746:	e8 15 df ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010274b:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102750:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102753:	85 c0                	test   %eax,%eax
80102755:	75 a0                	jne    801026f7 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102757:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010275a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010275c:	5b                   	pop    %ebx
8010275d:	5e                   	pop    %esi
8010275e:	5d                   	pop    %ebp
8010275f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	68 ac 74 10 80       	push   $0x801074ac
80102768:	e8 03 dc ff ff       	call   80100370 <panic>
8010276d:	8d 76 00             	lea    0x0(%esi),%esi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ba:	b8 0a 00 00 00       	mov    $0xa,%eax
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027de:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
8010284d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102850:	31 db                	xor    %ebx,%ebx
80102852:	88 45 b7             	mov    %al,-0x49(%ebp)
80102855:	bf 70 00 00 00       	mov    $0x70,%edi
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102860:	89 d8                	mov    %ebx,%eax
80102862:	89 fa                	mov    %edi,%edx
80102864:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102865:	b9 71 00 00 00       	mov    $0x71,%ecx
8010286a:	89 ca                	mov    %ecx,%edx
8010286c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	89 fa                	mov    %edi,%edx
80102872:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102875:	b8 02 00 00 00       	mov    $0x2,%eax
8010287a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287b:	89 ca                	mov    %ecx,%edx
8010287d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010287e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102881:	89 fa                	mov    %edi,%edx
80102883:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102886:	b8 04 00 00 00       	mov    $0x4,%eax
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010288f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 fa                	mov    %edi,%edx
80102894:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102897:	b8 07 00 00 00       	mov    $0x7,%eax
8010289c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	89 ca                	mov    %ecx,%edx
8010289f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a3:	89 fa                	mov    %edi,%edx
801028a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028a8:	b8 08 00 00 00       	mov    $0x8,%eax
801028ad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ae:	89 ca                	mov    %ecx,%edx
801028b0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b4:	89 fa                	mov    %edi,%edx
801028b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028b9:	b8 09 00 00 00       	mov    $0x9,%eax
801028be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bf:	89 ca                	mov    %ecx,%edx
801028c1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c5:	89 fa                	mov    %edi,%edx
801028c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801028cf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d3:	84 c0                	test   %al,%al
801028d5:	78 89                	js     80102860 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d7:	89 d8                	mov    %ebx,%eax
801028d9:	89 fa                	mov    %edi,%edx
801028db:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028df:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 fa                	mov    %edi,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028f0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 fa                	mov    %edi,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102901:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 fa                	mov    %edi,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102912:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 fa                	mov    %edi,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102923:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 fa                	mov    %edi,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102934:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	56                   	push   %esi
80102943:	50                   	push   %eax
80102944:	e8 d7 1b 00 00       	call   80104520 <memcmp>
80102949:	83 c4 10             	add    $0x10,%esp
8010294c:	85 c0                	test   %eax,%eax
8010294e:	0f 85 0c ff ff ff    	jne    80102860 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102954:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102958:	75 78                	jne    801029d2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010295d:	89 c2                	mov    %eax,%edx
8010295f:	83 e0 0f             	and    $0xf,%eax
80102962:	c1 ea 04             	shr    $0x4,%edx
80102965:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102968:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010296e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102971:	89 c2                	mov    %eax,%edx
80102973:	83 e0 0f             	and    $0xf,%eax
80102976:	c1 ea 04             	shr    $0x4,%edx
80102979:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102982:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102985:	89 c2                	mov    %eax,%edx
80102987:	83 e0 0f             	and    $0xf,%eax
8010298a:	c1 ea 04             	shr    $0x4,%edx
8010298d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102990:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102993:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102996:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102999:	89 c2                	mov    %eax,%edx
8010299b:	83 e0 0f             	and    $0xf,%eax
8010299e:	c1 ea 04             	shr    $0x4,%edx
801029a1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ad:	89 c2                	mov    %eax,%edx
801029af:	83 e0 0f             	and    $0xf,%eax
801029b2:	c1 ea 04             	shr    $0x4,%edx
801029b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029be:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c1:	89 c2                	mov    %eax,%edx
801029c3:	83 e0 0f             	and    $0xf,%eax
801029c6:	c1 ea 04             	shr    $0x4,%edx
801029c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d2:	8b 75 08             	mov    0x8(%ebp),%esi
801029d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d8:	89 06                	mov    %eax,(%esi)
801029da:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029dd:	89 46 04             	mov    %eax,0x4(%esi)
801029e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e3:	89 46 08             	mov    %eax,0x8(%esi)
801029e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029e9:	89 46 0c             	mov    %eax,0xc(%esi)
801029ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ef:	89 46 10             	mov    %eax,0x10(%esi)
801029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029f8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a02:	5b                   	pop    %ebx
80102a03:	5e                   	pop    %esi
80102a04:	5f                   	pop    %edi
80102a05:	5d                   	pop    %ebp
80102a06:	c3                   	ret    
80102a07:	66 90                	xchg   %ax,%ax
80102a09:	66 90                	xchg   %ax,%ax
80102a0b:	66 90                	xchg   %ax,%ax
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 85 00 00 00    	jle    80102aa3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
80102a24:	31 db                	xor    %ebx,%ebx
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a54:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 07 1b 00 00       	call   80104580 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	f3 c3                	repz ret 
80102aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ab7:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102abd:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ac3:	e8 08 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac8:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ace:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ad1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad8:	7e 1f                	jle    80102af9 <write_head+0x49>
80102ada:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ae1:	31 d2                	xor    %edx,%edx
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ae8:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102aee:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102af2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102af5:	39 c2                	cmp    %eax,%edx
80102af7:	75 ef                	jne    80102ae8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102af9:	83 ec 0c             	sub    $0xc,%esp
80102afc:	53                   	push   %ebx
80102afd:	e8 9e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b02:	89 1c 24             	mov    %ebx,(%esp)
80102b05:	e8 d6 d6 ff ff       	call   801001e0 <brelse>
}
80102b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b0d:	c9                   	leave  
80102b0e:	c3                   	ret    
80102b0f:	90                   	nop

80102b10 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b1a:	68 bc 74 10 80       	push   $0x801074bc
80102b1f:	68 a0 26 11 80       	push   $0x801126a0
80102b24:	e8 57 17 00 00       	call   80104280 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 5b e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b3c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b42:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b48:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b55:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b5d:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b6c:	31 d2                	xor    %edx,%edx
80102b6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 da                	cmp    %ebx,%edx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba1:	c9                   	leave  
80102ba2:	c3                   	ret    
80102ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 a0 26 11 80       	push   $0x801126a0
80102bbb:	e8 e0 16 00 00       	call   801042a0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 a0 26 11 80       	push   $0x801126a0
80102bd0:	68 a0 26 11 80       	push   $0x801126a0
80102bd5:	e8 16 12 00 00       	call   80103df0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bdd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102beb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c02:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c07:	68 a0 26 11 80       	push   $0x801126a0
80102c0c:	e8 6f 18 00 00       	call   80104480 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 a0 26 11 80       	push   $0x801126a0
80102c2e:	e8 6d 16 00 00       	call   801042a0 <acquire>
  log.outstanding -= 1;
80102c33:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c38:	8b 1d e0 26 11 80    	mov    0x801126e0,%ebx
80102c3e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c41:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c44:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c46:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c4b:	0f 85 23 01 00 00    	jne    80102d74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c51:	85 c0                	test   %eax,%eax
80102c53:	0f 85 f7 00 00 00    	jne    80102d50 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c59:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c5c:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c63:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c66:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c68:	68 a0 26 11 80       	push   $0x801126a0
80102c6d:	e8 0e 18 00 00       	call   80104480 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c72:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c78:	83 c4 10             	add    $0x10,%esp
80102c7b:	85 c9                	test   %ecx,%ecx
80102c7d:	0f 8e 8a 00 00 00    	jle    80102d0d <end_op+0xed>
80102c83:	90                   	nop
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c88:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c8d:	83 ec 08             	sub    $0x8,%esp
80102c90:	01 d8                	add    %ebx,%eax
80102c92:	83 c0 01             	add    $0x1,%eax
80102c95:	50                   	push   %eax
80102c96:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102c9c:	e8 2f d4 ff ff       	call   801000d0 <bread>
80102ca1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca3:	58                   	pop    %eax
80102ca4:	5a                   	pop    %edx
80102ca5:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cac:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb5:	e8 16 d4 ff ff       	call   801000d0 <bread>
80102cba:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cbc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cbf:	83 c4 0c             	add    $0xc,%esp
80102cc2:	68 00 02 00 00       	push   $0x200
80102cc7:	50                   	push   %eax
80102cc8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ccb:	50                   	push   %eax
80102ccc:	e8 af 18 00 00       	call   80104580 <memmove>
    bwrite(to);  // write the log
80102cd1:	89 34 24             	mov    %esi,(%esp)
80102cd4:	e8 c7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd9:	89 3c 24             	mov    %edi,(%esp)
80102cdc:	e8 ff d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 f7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
80102cec:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cf2:	7c 94                	jl     80102c88 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cf4:	e8 b7 fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf9:	e8 12 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cfe:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d05:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d08:	e8 a3 fd ff ff       	call   80102ab0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	68 a0 26 11 80       	push   $0x801126a0
80102d15:	e8 86 15 00 00       	call   801042a0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d1a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d21:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d28:	00 00 00 
    wakeup(&log);
80102d2b:	e8 70 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102d30:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d37:	e8 44 17 00 00       	call   80104480 <release>
80102d3c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d42:	5b                   	pop    %ebx
80102d43:	5e                   	pop    %esi
80102d44:	5f                   	pop    %edi
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
80102d47:	89 f6                	mov    %esi,%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d50:	83 ec 0c             	sub    $0xc,%esp
80102d53:	68 a0 26 11 80       	push   $0x801126a0
80102d58:	e8 43 12 00 00       	call   80103fa0 <wakeup>
  }
  release(&log.lock);
80102d5d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d64:	e8 17 17 00 00       	call   80104480 <release>
80102d69:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5f                   	pop    %edi
80102d72:	5d                   	pop    %ebp
80102d73:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d74:	83 ec 0c             	sub    $0xc,%esp
80102d77:	68 c0 74 10 80       	push   $0x801074c0
80102d7c:	e8 ef d5 ff ff       	call   80100370 <panic>
80102d81:	eb 0d                	jmp    80102d90 <log_write>
80102d83:	90                   	nop
80102d84:	90                   	nop
80102d85:	90                   	nop
80102d86:	90                   	nop
80102d87:	90                   	nop
80102d88:	90                   	nop
80102d89:	90                   	nop
80102d8a:	90                   	nop
80102d8b:	90                   	nop
80102d8c:	90                   	nop
80102d8d:	90                   	nop
80102d8e:	90                   	nop
80102d8f:	90                   	nop

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 97 00 00 00    	jg     80102e40 <log_write+0xb0>
80102da9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 87 00 00 00    	jge    80102e40 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 87 00 00 00    	jle    80102e4d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 a0 26 11 80       	push   $0x801126a0
80102dce:	e8 cd 14 00 00       	call   801042a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 fa 00             	cmp    $0x0,%edx
80102ddf:	7e 50                	jle    80102e31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 d0                	cmp    %edx,%eax
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c2 01             	add    $0x1,%edx
80102e0a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e13:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e1e:	e9 5d 16 00 00       	jmp    80104480 <release>
80102e23:	90                   	nop
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e28:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102e2f:	eb df                	jmp    80102e10 <log_write+0x80>
80102e31:	8b 43 08             	mov    0x8(%ebx),%eax
80102e34:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e39:	75 d5                	jne    80102e10 <log_write+0x80>
80102e3b:	eb ca                	jmp    80102e07 <log_write+0x77>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 cf 74 10 80       	push   $0x801074cf
80102e48:	e8 23 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e4d:	83 ec 0c             	sub    $0xc,%esp
80102e50:	68 e5 74 10 80       	push   $0x801074e5
80102e55:	e8 16 d5 ff ff       	call   80100370 <panic>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e66:	e8 65 f8 ff ff       	call   801026d0 <cpunum>
80102e6b:	83 ec 08             	sub    $0x8,%esp
80102e6e:	50                   	push   %eax
80102e6f:	68 00 75 10 80       	push   $0x80107500
80102e74:	e8 e7 d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e79:	e8 92 29 00 00       	call   80105810 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e7e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e85:	b8 01 00 00 00       	mov    $0x1,%eax
80102e8a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e91:	e8 6a 0c 00 00       	call   80103b00 <scheduler>
80102e96:	8d 76 00             	lea    0x0(%esi),%esi
80102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ea0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 75 3b 00 00       	call   80106a20 <switchkvm>
  seginit();
80102eab:	e8 90 39 00 00       	call   80106840 <seginit>
  lapicinit();
80102eb0:	e8 1b f7 ff ff       	call   801025d0 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ecf:	83 ec 08             	sub    $0x8,%esp
80102ed2:	68 00 00 40 80       	push   $0x80400000
80102ed7:	68 28 76 11 80       	push   $0x80117628
80102edc:	e8 bf f4 ff ff       	call   801023a0 <kinit1>
  kvmalloc();      // kernel page table
80102ee1:	e8 1a 3b 00 00       	call   80106a00 <kvmalloc>
  mpinit();        // detect other processors
80102ee6:	e8 b5 01 00 00       	call   801030a0 <mpinit>
  lapicinit();     // interrupt controller
80102eeb:	e8 e0 f6 ff ff       	call   801025d0 <lapicinit>
  seginit();       // segment descriptors
80102ef0:	e8 4b 39 00 00       	call   80106840 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ef5:	e8 d6 f7 ff ff       	call   801026d0 <cpunum>
80102efa:	5a                   	pop    %edx
80102efb:	59                   	pop    %ecx
80102efc:	50                   	push   %eax
80102efd:	68 11 75 10 80       	push   $0x80107511
80102f02:	e8 59 d7 ff ff       	call   80100660 <cprintf>
  picinit();       // another interrupt controller
80102f07:	e8 a4 03 00 00       	call   801032b0 <picinit>
  ioapicinit();    // another interrupt controller
80102f0c:	e8 af f2 ff ff       	call   801021c0 <ioapicinit>
  consoleinit();   // console hardware
80102f11:	e8 8a da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f16:	e8 f5 2b 00 00       	call   80105b10 <uartinit>
  pinit();         // process table
80102f1b:	e8 40 09 00 00       	call   80103860 <pinit>
  tvinit();        // trap vectors
80102f20:	e8 4b 28 00 00       	call   80105770 <tvinit>
  binit();         // buffer cache
80102f25:	e8 16 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f2a:	e8 01 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk
80102f2f:	e8 5c f0 ff ff       	call   80101f90 <ideinit>
  if(!ismp)
80102f34:	8b 1d 84 27 11 80    	mov    0x80112784,%ebx
80102f3a:	83 c4 10             	add    $0x10,%esp
80102f3d:	85 db                	test   %ebx,%ebx
80102f3f:	0f 84 ca 00 00 00    	je     8010300f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f45:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102f48:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f4d:	68 8a 00 00 00       	push   $0x8a
80102f52:	68 8c a4 10 80       	push   $0x8010a48c
80102f57:	68 00 70 00 80       	push   $0x80007000
80102f5c:	e8 1f 16 00 00       	call   80104580 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f61:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f68:	00 00 00 
80102f6b:	83 c4 10             	add    $0x10,%esp
80102f6e:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f73:	39 d8                	cmp    %ebx,%eax
80102f75:	76 7c                	jbe    80102ff3 <main+0x133>
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80102f80:	e8 4b f7 ff ff       	call   801026d0 <cpunum>
80102f85:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f8b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f90:	39 c3                	cmp    %eax,%ebx
80102f92:	74 46                	je     80102fda <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f94:	e8 d7 f4 ff ff       	call   80102470 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f99:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f9c:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fa1:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102fa8:	2e 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fab:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fb0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fb7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102fba:	68 00 70 00 00       	push   $0x7000
80102fbf:	0f b6 03             	movzbl (%ebx),%eax
80102fc2:	50                   	push   %eax
80102fc3:	e8 d8 f7 ff ff       	call   801027a0 <lapicstartap>
80102fc8:	83 c4 10             	add    $0x10,%esp
80102fcb:	90                   	nop
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fd0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 f6                	je     80102fd0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fda:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102fe1:	00 00 00 
80102fe4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102fea:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fef:	39 c3                	cmp    %eax,%ebx
80102ff1:	72 8d                	jb     80102f80 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ff3:	83 ec 08             	sub    $0x8,%esp
80102ff6:	68 00 00 00 8e       	push   $0x8e000000
80102ffb:	68 00 00 40 80       	push   $0x80400000
80103000:	e8 0b f4 ff ff       	call   80102410 <kinit2>
  userinit();      // first user process
80103005:	e8 76 08 00 00       	call   80103880 <userinit>
  mpmain();        // finish this processor's setup
8010300a:	e8 51 fe ff ff       	call   80102e60 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
8010300f:	e8 fc 26 00 00       	call   80105710 <timerinit>
80103014:	e9 2c ff ff ff       	jmp    80102f45 <main+0x85>
80103019:	66 90                	xchg   %ax,%ax
8010301b:	66 90                	xchg   %ax,%ax
8010301d:	66 90                	xchg   %ax,%ax
8010301f:	90                   	nop

80103020 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103025:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010302c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103032:	39 de                	cmp    %ebx,%esi
80103034:	73 48                	jae    8010307e <mpsearch1+0x5e>
80103036:	8d 76 00             	lea    0x0(%esi),%esi
80103039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103040:	83 ec 04             	sub    $0x4,%esp
80103043:	8d 7e 10             	lea    0x10(%esi),%edi
80103046:	6a 04                	push   $0x4
80103048:	68 28 75 10 80       	push   $0x80107528
8010304d:	56                   	push   %esi
8010304e:	e8 cd 14 00 00       	call   80104520 <memcmp>
80103053:	83 c4 10             	add    $0x10,%esp
80103056:	85 c0                	test   %eax,%eax
80103058:	75 1e                	jne    80103078 <mpsearch1+0x58>
8010305a:	8d 7e 10             	lea    0x10(%esi),%edi
8010305d:	89 f2                	mov    %esi,%edx
8010305f:	31 c9                	xor    %ecx,%ecx
80103061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103068:	0f b6 02             	movzbl (%edx),%eax
8010306b:	83 c2 01             	add    $0x1,%edx
8010306e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103070:	39 fa                	cmp    %edi,%edx
80103072:	75 f4                	jne    80103068 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103074:	84 c9                	test   %cl,%cl
80103076:	74 10                	je     80103088 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103078:	39 fb                	cmp    %edi,%ebx
8010307a:	89 fe                	mov    %edi,%esi
8010307c:	77 c2                	ja     80103040 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010307e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103081:	31 c0                	xor    %eax,%eax
}
80103083:	5b                   	pop    %ebx
80103084:	5e                   	pop    %esi
80103085:	5f                   	pop    %edi
80103086:	5d                   	pop    %ebp
80103087:	c3                   	ret    
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308b:	89 f0                	mov    %esi,%eax
8010308d:	5b                   	pop    %ebx
8010308e:	5e                   	pop    %esi
8010308f:	5f                   	pop    %edi
80103090:	5d                   	pop    %ebp
80103091:	c3                   	ret    
80103092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	57                   	push   %edi
801030a4:	56                   	push   %esi
801030a5:	53                   	push   %ebx
801030a6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030b7:	c1 e0 08             	shl    $0x8,%eax
801030ba:	09 d0                	or     %edx,%eax
801030bc:	c1 e0 04             	shl    $0x4,%eax
801030bf:	85 c0                	test   %eax,%eax
801030c1:	75 1b                	jne    801030de <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030d1:	c1 e0 08             	shl    $0x8,%eax
801030d4:	09 d0                	or     %edx,%eax
801030d6:	c1 e0 0a             	shl    $0xa,%eax
801030d9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030de:	ba 00 04 00 00       	mov    $0x400,%edx
801030e3:	e8 38 ff ff ff       	call   80103020 <mpsearch1>
801030e8:	85 c0                	test   %eax,%eax
801030ea:	89 c6                	mov    %eax,%esi
801030ec:	0f 84 66 01 00 00    	je     80103258 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030f2:	8b 5e 04             	mov    0x4(%esi),%ebx
801030f5:	85 db                	test   %ebx,%ebx
801030f7:	0f 84 d6 00 00 00    	je     801031d3 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030fd:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	6a 04                	push   $0x4
80103108:	68 2d 75 10 80       	push   $0x8010752d
8010310d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010310e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103111:	e8 0a 14 00 00       	call   80104520 <memcmp>
80103116:	83 c4 10             	add    $0x10,%esp
80103119:	85 c0                	test   %eax,%eax
8010311b:	0f 85 b2 00 00 00    	jne    801031d3 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103121:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103128:	3c 01                	cmp    $0x1,%al
8010312a:	74 08                	je     80103134 <mpinit+0x94>
8010312c:	3c 04                	cmp    $0x4,%al
8010312e:	0f 85 9f 00 00 00    	jne    801031d3 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103134:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010313b:	85 ff                	test   %edi,%edi
8010313d:	74 1e                	je     8010315d <mpinit+0xbd>
8010313f:	31 d2                	xor    %edx,%edx
80103141:	31 c0                	xor    %eax,%eax
80103143:	90                   	nop
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103148:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010314f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103150:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103153:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103155:	39 c7                	cmp    %eax,%edi
80103157:	75 ef                	jne    80103148 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103159:	84 d2                	test   %dl,%dl
8010315b:	75 76                	jne    801031d3 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010315d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103160:	85 ff                	test   %edi,%edi
80103162:	74 6f                	je     801031d3 <mpinit+0x133>
    return;
  ismp = 1;
80103164:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010316b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010316e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103174:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103179:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103180:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103186:	01 f9                	add    %edi,%ecx
80103188:	39 c8                	cmp    %ecx,%eax
8010318a:	0f 83 a0 00 00 00    	jae    80103230 <mpinit+0x190>
    switch(*p){
80103190:	80 38 04             	cmpb   $0x4,(%eax)
80103193:	0f 87 87 00 00 00    	ja     80103220 <mpinit+0x180>
80103199:	0f b6 10             	movzbl (%eax),%edx
8010319c:	ff 24 95 34 75 10 80 	jmp    *-0x7fef8acc(,%edx,4)
801031a3:	90                   	nop
801031a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031a8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031ab:	39 c1                	cmp    %eax,%ecx
801031ad:	77 e1                	ja     80103190 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801031af:	a1 84 27 11 80       	mov    0x80112784,%eax
801031b4:	85 c0                	test   %eax,%eax
801031b6:	75 78                	jne    80103230 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031b8:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
801031bf:	00 00 00 
    lapic = 0;
801031c2:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801031c9:	00 00 00 
    ioapicid = 0;
801031cc:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031d6:	5b                   	pop    %ebx
801031d7:	5e                   	pop    %esi
801031d8:	5f                   	pop    %edi
801031d9:	5d                   	pop    %ebp
801031da:	c3                   	ret    
801031db:	90                   	nop
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031e0:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
801031e6:	83 fa 07             	cmp    $0x7,%edx
801031e9:	7f 19                	jg     80103204 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031eb:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031ef:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
801031f5:	83 c2 01             	add    $0x1,%edx
801031f8:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031fe:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103204:	83 c0 14             	add    $0x14,%eax
      continue;
80103207:	eb a2                	jmp    801031ab <mpinit+0x10b>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103210:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103214:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103217:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010321d:	eb 8c                	jmp    801031ab <mpinit+0x10b>
8010321f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103220:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103227:	00 00 00 
      break;
8010322a:	e9 7c ff ff ff       	jmp    801031ab <mpinit+0x10b>
8010322f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103230:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103234:	74 9d                	je     801031d3 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103236:	ba 22 00 00 00       	mov    $0x22,%edx
8010323b:	b8 70 00 00 00       	mov    $0x70,%eax
80103240:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103241:	ba 23 00 00 00       	mov    $0x23,%edx
80103246:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103247:	83 c8 01             	or     $0x1,%eax
8010324a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010324b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324e:	5b                   	pop    %ebx
8010324f:	5e                   	pop    %esi
80103250:	5f                   	pop    %edi
80103251:	5d                   	pop    %ebp
80103252:	c3                   	ret    
80103253:	90                   	nop
80103254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103258:	ba 00 00 01 00       	mov    $0x10000,%edx
8010325d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103262:	e8 b9 fd ff ff       	call   80103020 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103267:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103269:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010326b:	0f 85 81 fe ff ff    	jne    801030f2 <mpinit+0x52>
80103271:	e9 5d ff ff ff       	jmp    801031d3 <mpinit+0x133>
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103280:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103281:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103286:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010328b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010328d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103290:	d3 c0                	rol    %cl,%eax
80103292:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103299:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010329f:	ee                   	out    %al,(%dx)
801032a0:	ba a1 00 00 00       	mov    $0xa1,%edx
801032a5:	66 c1 e8 08          	shr    $0x8,%ax
801032a9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032aa:	5d                   	pop    %ebp
801032ab:	c3                   	ret    
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032b0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032b0:	55                   	push   %ebp
801032b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032b6:	89 e5                	mov    %esp,%ebp
801032b8:	57                   	push   %edi
801032b9:	56                   	push   %esi
801032ba:	53                   	push   %ebx
801032bb:	bb 21 00 00 00       	mov    $0x21,%ebx
801032c0:	89 da                	mov    %ebx,%edx
801032c2:	ee                   	out    %al,(%dx)
801032c3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032c8:	89 ca                	mov    %ecx,%edx
801032ca:	ee                   	out    %al,(%dx)
801032cb:	bf 11 00 00 00       	mov    $0x11,%edi
801032d0:	be 20 00 00 00       	mov    $0x20,%esi
801032d5:	89 f8                	mov    %edi,%eax
801032d7:	89 f2                	mov    %esi,%edx
801032d9:	ee                   	out    %al,(%dx)
801032da:	b8 20 00 00 00       	mov    $0x20,%eax
801032df:	89 da                	mov    %ebx,%edx
801032e1:	ee                   	out    %al,(%dx)
801032e2:	b8 04 00 00 00       	mov    $0x4,%eax
801032e7:	ee                   	out    %al,(%dx)
801032e8:	b8 03 00 00 00       	mov    $0x3,%eax
801032ed:	ee                   	out    %al,(%dx)
801032ee:	bb a0 00 00 00       	mov    $0xa0,%ebx
801032f3:	89 f8                	mov    %edi,%eax
801032f5:	89 da                	mov    %ebx,%edx
801032f7:	ee                   	out    %al,(%dx)
801032f8:	b8 28 00 00 00       	mov    $0x28,%eax
801032fd:	89 ca                	mov    %ecx,%edx
801032ff:	ee                   	out    %al,(%dx)
80103300:	b8 02 00 00 00       	mov    $0x2,%eax
80103305:	ee                   	out    %al,(%dx)
80103306:	b8 03 00 00 00       	mov    $0x3,%eax
8010330b:	ee                   	out    %al,(%dx)
8010330c:	bf 68 00 00 00       	mov    $0x68,%edi
80103311:	89 f2                	mov    %esi,%edx
80103313:	89 f8                	mov    %edi,%eax
80103315:	ee                   	out    %al,(%dx)
80103316:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010331b:	89 c8                	mov    %ecx,%eax
8010331d:	ee                   	out    %al,(%dx)
8010331e:	89 f8                	mov    %edi,%eax
80103320:	89 da                	mov    %ebx,%edx
80103322:	ee                   	out    %al,(%dx)
80103323:	89 c8                	mov    %ecx,%eax
80103325:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103326:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010332d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103331:	74 10                	je     80103343 <picinit+0x93>
80103333:	ba 21 00 00 00       	mov    $0x21,%edx
80103338:	ee                   	out    %al,(%dx)
80103339:	ba a1 00 00 00       	mov    $0xa1,%edx
8010333e:	66 c1 e8 08          	shr    $0x8,%ax
80103342:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103343:	5b                   	pop    %ebx
80103344:	5e                   	pop    %esi
80103345:	5f                   	pop    %edi
80103346:	5d                   	pop    %ebp
80103347:	c3                   	ret    
80103348:	66 90                	xchg   %ax,%ax
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	8b 75 08             	mov    0x8(%ebp),%esi
8010335c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010335f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103365:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010336b:	e8 e0 d9 ff ff       	call   80100d50 <filealloc>
80103370:	85 c0                	test   %eax,%eax
80103372:	89 06                	mov    %eax,(%esi)
80103374:	0f 84 a8 00 00 00    	je     80103422 <pipealloc+0xd2>
8010337a:	e8 d1 d9 ff ff       	call   80100d50 <filealloc>
8010337f:	85 c0                	test   %eax,%eax
80103381:	89 03                	mov    %eax,(%ebx)
80103383:	0f 84 87 00 00 00    	je     80103410 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103389:	e8 e2 f0 ff ff       	call   80102470 <kalloc>
8010338e:	85 c0                	test   %eax,%eax
80103390:	89 c7                	mov    %eax,%edi
80103392:	0f 84 b0 00 00 00    	je     80103448 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103398:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010339b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033a2:	00 00 00 
  p->writeopen = 1;
801033a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033ac:	00 00 00 
  p->nwrite = 0;
801033af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033b6:	00 00 00 
  p->nread = 0;
801033b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033c0:	00 00 00 
  initlock(&p->lock, "pipe");
801033c3:	68 48 75 10 80       	push   $0x80107548
801033c8:	50                   	push   %eax
801033c9:	e8 b2 0e 00 00       	call   80104280 <initlock>
  (*f0)->type = FD_PIPE;
801033ce:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033d0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801033d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033d9:	8b 06                	mov    (%esi),%eax
801033db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033df:	8b 06                	mov    (%esi),%eax
801033e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033e5:	8b 06                	mov    (%esi),%eax
801033e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033ea:	8b 03                	mov    (%ebx),%eax
801033ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033f2:	8b 03                	mov    (%ebx),%eax
801033f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033f8:	8b 03                	mov    (%ebx),%eax
801033fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033fe:	8b 03                	mov    (%ebx),%eax
80103400:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103406:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103408:	5b                   	pop    %ebx
80103409:	5e                   	pop    %esi
8010340a:	5f                   	pop    %edi
8010340b:	5d                   	pop    %ebp
8010340c:	c3                   	ret    
8010340d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103410:	8b 06                	mov    (%esi),%eax
80103412:	85 c0                	test   %eax,%eax
80103414:	74 1e                	je     80103434 <pipealloc+0xe4>
    fileclose(*f0);
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	50                   	push   %eax
8010341a:	e8 f1 d9 ff ff       	call   80100e10 <fileclose>
8010341f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103422:	8b 03                	mov    (%ebx),%eax
80103424:	85 c0                	test   %eax,%eax
80103426:	74 0c                	je     80103434 <pipealloc+0xe4>
    fileclose(*f1);
80103428:	83 ec 0c             	sub    $0xc,%esp
8010342b:	50                   	push   %eax
8010342c:	e8 df d9 ff ff       	call   80100e10 <fileclose>
80103431:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103434:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010343c:	5b                   	pop    %ebx
8010343d:	5e                   	pop    %esi
8010343e:	5f                   	pop    %edi
8010343f:	5d                   	pop    %ebp
80103440:	c3                   	ret    
80103441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103448:	8b 06                	mov    (%esi),%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	75 c8                	jne    80103416 <pipealloc+0xc6>
8010344e:	eb d2                	jmp    80103422 <pipealloc+0xd2>

80103450 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	56                   	push   %esi
80103454:	53                   	push   %ebx
80103455:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103458:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010345b:	83 ec 0c             	sub    $0xc,%esp
8010345e:	53                   	push   %ebx
8010345f:	e8 3c 0e 00 00       	call   801042a0 <acquire>
  if(writable){
80103464:	83 c4 10             	add    $0x10,%esp
80103467:	85 f6                	test   %esi,%esi
80103469:	74 45                	je     801034b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010346b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103471:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103474:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010347b:	00 00 00 
    wakeup(&p->nread);
8010347e:	50                   	push   %eax
8010347f:	e8 1c 0b 00 00       	call   80103fa0 <wakeup>
80103484:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103487:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010348d:	85 d2                	test   %edx,%edx
8010348f:	75 0a                	jne    8010349b <pipeclose+0x4b>
80103491:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103497:	85 c0                	test   %eax,%eax
80103499:	74 35                	je     801034d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010349b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010349e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a1:	5b                   	pop    %ebx
801034a2:	5e                   	pop    %esi
801034a3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034a4:	e9 d7 0f 00 00       	jmp    80104480 <release>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034b6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034c0:	00 00 00 
    wakeup(&p->nwrite);
801034c3:	50                   	push   %eax
801034c4:	e8 d7 0a 00 00       	call   80103fa0 <wakeup>
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	eb b9                	jmp    80103487 <pipeclose+0x37>
801034ce:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 a7 0f 00 00       	call   80104480 <release>
    kfree((char*)p);
801034d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034dc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801034df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034e2:	5b                   	pop    %ebx
801034e3:	5e                   	pop    %esi
801034e4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801034e5:	e9 d6 ed ff ff       	jmp    801022c0 <kfree>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 28             	sub    $0x28,%esp
801034f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
801034fc:	57                   	push   %edi
801034fd:	e8 9e 0d 00 00       	call   801042a0 <acquire>
  for(i = 0; i < n; i++){
80103502:	8b 45 10             	mov    0x10(%ebp),%eax
80103505:	83 c4 10             	add    $0x10,%esp
80103508:	85 c0                	test   %eax,%eax
8010350a:	0f 8e c6 00 00 00    	jle    801035d6 <pipewrite+0xe6>
80103510:	8b 45 0c             	mov    0xc(%ebp),%eax
80103513:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103519:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010351f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103528:	03 45 10             	add    0x10(%ebp),%eax
8010352b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010352e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103534:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010353a:	39 d1                	cmp    %edx,%ecx
8010353c:	0f 85 cf 00 00 00    	jne    80103611 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103542:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103548:	85 d2                	test   %edx,%edx
8010354a:	0f 84 a8 00 00 00    	je     801035f8 <pipewrite+0x108>
80103550:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103557:	8b 42 24             	mov    0x24(%edx),%eax
8010355a:	85 c0                	test   %eax,%eax
8010355c:	74 25                	je     80103583 <pipewrite+0x93>
8010355e:	e9 95 00 00 00       	jmp    801035f8 <pipewrite+0x108>
80103563:	90                   	nop
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103568:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010356e:	85 c0                	test   %eax,%eax
80103570:	0f 84 82 00 00 00    	je     801035f8 <pipewrite+0x108>
80103576:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010357c:	8b 40 24             	mov    0x24(%eax),%eax
8010357f:	85 c0                	test   %eax,%eax
80103581:	75 75                	jne    801035f8 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	56                   	push   %esi
80103587:	e8 14 0a 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010358c:	59                   	pop    %ecx
8010358d:	58                   	pop    %eax
8010358e:	57                   	push   %edi
8010358f:	53                   	push   %ebx
80103590:	e8 5b 08 00 00       	call   80103df0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103595:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010359b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035a1:	83 c4 10             	add    $0x10,%esp
801035a4:	05 00 02 00 00       	add    $0x200,%eax
801035a9:	39 c2                	cmp    %eax,%edx
801035ab:	74 bb                	je     80103568 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035b0:	8d 4a 01             	lea    0x1(%edx),%ecx
801035b3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035b7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035bd:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801035c3:	0f b6 00             	movzbl (%eax),%eax
801035c6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801035ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801035cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801035d0:	0f 85 58 ff ff ff    	jne    8010352e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035d6:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801035dc:	83 ec 0c             	sub    $0xc,%esp
801035df:	52                   	push   %edx
801035e0:	e8 bb 09 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
801035e5:	89 3c 24             	mov    %edi,(%esp)
801035e8:	e8 93 0e 00 00       	call   80104480 <release>
  return n;
801035ed:	83 c4 10             	add    $0x10,%esp
801035f0:	8b 45 10             	mov    0x10(%ebp),%eax
801035f3:	eb 14                	jmp    80103609 <pipewrite+0x119>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
801035f8:	83 ec 0c             	sub    $0xc,%esp
801035fb:	57                   	push   %edi
801035fc:	e8 7f 0e 00 00       	call   80104480 <release>
        return -1;
80103601:	83 c4 10             	add    $0x10,%esp
80103604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103609:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010360c:	5b                   	pop    %ebx
8010360d:	5e                   	pop    %esi
8010360e:	5f                   	pop    %edi
8010360f:	5d                   	pop    %ebp
80103610:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103611:	89 ca                	mov    %ecx,%edx
80103613:	eb 98                	jmp    801035ad <pipewrite+0xbd>
80103615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103620 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 18             	sub    $0x18,%esp
80103629:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010362c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010362f:	53                   	push   %ebx
80103630:	e8 6b 0c 00 00       	call   801042a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010363e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103644:	75 6a                	jne    801036b0 <piperead+0x90>
80103646:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010364c:	85 f6                	test   %esi,%esi
8010364e:	0f 84 cc 00 00 00    	je     80103720 <piperead+0x100>
80103654:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010365a:	eb 2d                	jmp    80103689 <piperead+0x69>
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103660:	83 ec 08             	sub    $0x8,%esp
80103663:	53                   	push   %ebx
80103664:	56                   	push   %esi
80103665:	e8 86 07 00 00       	call   80103df0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103673:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103679:	75 35                	jne    801036b0 <piperead+0x90>
8010367b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103681:	85 d2                	test   %edx,%edx
80103683:	0f 84 97 00 00 00    	je     80103720 <piperead+0x100>
    if(proc->killed){
80103689:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103690:	8b 4a 24             	mov    0x24(%edx),%ecx
80103693:	85 c9                	test   %ecx,%ecx
80103695:	74 c9                	je     80103660 <piperead+0x40>
      release(&p->lock);
80103697:	83 ec 0c             	sub    $0xc,%esp
8010369a:	53                   	push   %ebx
8010369b:	e8 e0 0d 00 00       	call   80104480 <release>
      return -1;
801036a0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036a3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036ab:	5b                   	pop    %ebx
801036ac:	5e                   	pop    %esi
801036ad:	5f                   	pop    %edi
801036ae:	5d                   	pop    %ebp
801036af:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036b0:	8b 45 10             	mov    0x10(%ebp),%eax
801036b3:	85 c0                	test   %eax,%eax
801036b5:	7e 69                	jle    80103720 <piperead+0x100>
    if(p->nread == p->nwrite)
801036b7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036bd:	31 c9                	xor    %ecx,%ecx
801036bf:	eb 15                	jmp    801036d6 <piperead+0xb6>
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036ce:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801036d4:	74 5a                	je     80103730 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036d6:	8d 72 01             	lea    0x1(%edx),%esi
801036d9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036df:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801036e5:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
801036ea:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036ed:	83 c1 01             	add    $0x1,%ecx
801036f0:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801036f3:	75 d3                	jne    801036c8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036f5:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	52                   	push   %edx
801036ff:	e8 9c 08 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103704:	89 1c 24             	mov    %ebx,(%esp)
80103707:	e8 74 0d 00 00       	call   80104480 <release>
  return i;
8010370c:	8b 45 10             	mov    0x10(%ebp),%eax
8010370f:	83 c4 10             	add    $0x10,%esp
}
80103712:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103715:	5b                   	pop    %ebx
80103716:	5e                   	pop    %esi
80103717:	5f                   	pop    %edi
80103718:	5d                   	pop    %ebp
80103719:	c3                   	ret    
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103720:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103727:	eb cc                	jmp    801036f5 <piperead+0xd5>
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103730:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103733:	eb c0                	jmp    801036f5 <piperead+0xd5>
80103735:	66 90                	xchg   %ax,%ax
80103737:	66 90                	xchg   %ax,%ax
80103739:	66 90                	xchg   %ax,%ax
8010373b:	66 90                	xchg   %ax,%ax
8010373d:	66 90                	xchg   %ax,%ax
8010373f:	90                   	nop

80103740 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103744:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103749:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010374c:	68 a0 2d 11 80       	push   $0x80112da0
80103751:	e8 4a 0b 00 00       	call   801042a0 <acquire>
80103756:	83 c4 10             	add    $0x10,%esp
80103759:	eb 13                	jmp    8010376e <allocproc+0x2e>
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103760:	81 c3 00 01 00 00    	add    $0x100,%ebx
80103766:	81 fb d4 6d 11 80    	cmp    $0x80116dd4,%ebx
8010376c:	74 7a                	je     801037e8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010376e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103771:	85 c0                	test   %eax,%eax
80103773:	75 eb                	jne    80103760 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103775:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
8010377a:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010377d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103784:	68 a0 2d 11 80       	push   $0x80112da0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103789:	8d 50 01             	lea    0x1(%eax),%edx
8010378c:	89 43 10             	mov    %eax,0x10(%ebx)
8010378f:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  release(&ptable.lock);
80103795:	e8 e6 0c 00 00       	call   80104480 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010379a:	e8 d1 ec ff ff       	call   80102470 <kalloc>
8010379f:	83 c4 10             	add    $0x10,%esp
801037a2:	85 c0                	test   %eax,%eax
801037a4:	89 43 08             	mov    %eax,0x8(%ebx)
801037a7:	74 56                	je     801037ff <allocproc+0xbf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037a9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037af:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801037b2:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037b7:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037ba:	c7 40 14 5e 57 10 80 	movl   $0x8010575e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037c1:	6a 14                	push   $0x14
801037c3:	6a 00                	push   $0x0
801037c5:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037c6:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037c9:	e8 02 0d 00 00       	call   801044d0 <memset>
  p->context->eip = (uint)forkret;
801037ce:	8b 43 1c             	mov    0x1c(%ebx),%eax
  // {
  //   /* code */
  // }
  // p->sig_handler_arr

  return p;
801037d1:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801037d4:	c7 40 10 10 38 10 80 	movl   $0x80103810,0x10(%eax)
  // {
  //   /* code */
  // }
  // p->sig_handler_arr

  return p;
801037db:	89 d8                	mov    %ebx,%eax
}
801037dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e0:	c9                   	leave  
801037e1:	c3                   	ret    
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801037e8:	83 ec 0c             	sub    $0xc,%esp
801037eb:	68 a0 2d 11 80       	push   $0x80112da0
801037f0:	e8 8b 0c 00 00       	call   80104480 <release>
  return 0;
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	31 c0                	xor    %eax,%eax
  //   /* code */
  // }
  // p->sig_handler_arr

  return p;
}
801037fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037fd:	c9                   	leave  
801037fe:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801037ff:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103806:	eb d5                	jmp    801037dd <allocproc+0x9d>
80103808:	90                   	nop
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103810 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103816:	68 a0 2d 11 80       	push   $0x80112da0
8010381b:	e8 60 0c 00 00       	call   80104480 <release>

  if (first) {
80103820:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	85 c0                	test   %eax,%eax
8010382a:	75 04                	jne    80103830 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010382c:	c9                   	leave  
8010382d:	c3                   	ret    
8010382e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103830:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103833:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010383a:	00 00 00 
    iinit(ROOTDEV);
8010383d:	6a 01                	push   $0x1
8010383f:	e8 0c dc ff ff       	call   80101450 <iinit>
    initlog(ROOTDEV);
80103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010384b:	e8 c0 f2 ff ff       	call   80102b10 <initlog>
80103850:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103853:	c9                   	leave  
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103866:	68 4d 75 10 80       	push   $0x8010754d
8010386b:	68 a0 2d 11 80       	push   $0x80112da0
80103870:	e8 0b 0a 00 00       	call   80104280 <initlock>
}
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	c9                   	leave  
80103879:	c3                   	ret    
8010387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103880 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103887:	e8 b4 fe ff ff       	call   80103740 <allocproc>
8010388c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010388e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
80103893:	e8 f8 30 00 00       	call   80106990 <setupkvm>
80103898:	85 c0                	test   %eax,%eax
8010389a:	89 43 04             	mov    %eax,0x4(%ebx)
8010389d:	0f 84 bd 00 00 00    	je     80103960 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	68 2c 00 00 00       	push   $0x2c
801038ab:	68 60 a4 10 80       	push   $0x8010a460
801038b0:	50                   	push   %eax
801038b1:	e8 5a 32 00 00       	call   80106b10 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801038b6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801038b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038bf:	6a 4c                	push   $0x4c
801038c1:	6a 00                	push   $0x0
801038c3:	ff 73 18             	pushl  0x18(%ebx)
801038c6:	e8 05 0c 00 00       	call   801044d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038cb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ce:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038d3:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038d8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038df:	8b 43 18             	mov    0x18(%ebx),%eax
801038e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038f1:	8b 43 18             	mov    0x18(%ebx),%eax
801038f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038fc:	8b 43 18             	mov    0x18(%ebx),%eax
801038ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103910:	8b 43 18             	mov    0x18(%ebx),%eax
80103913:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010391a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010391d:	6a 10                	push   $0x10
8010391f:	68 6d 75 10 80       	push   $0x8010756d
80103924:	50                   	push   %eax
80103925:	e8 a6 0d 00 00       	call   801046d0 <safestrcpy>
  p->cwd = namei("/");
8010392a:	c7 04 24 76 75 10 80 	movl   $0x80107576,(%esp)
80103931:	e8 4a e5 ff ff       	call   80101e80 <namei>
80103936:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103939:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103940:	e8 5b 09 00 00       	call   801042a0 <acquire>

  p->state = RUNNABLE;
80103945:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010394c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103953:	e8 28 0b 00 00       	call   80104480 <release>
}
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 54 75 10 80       	push   $0x80107554
80103968:	e8 03 ca ff ff       	call   80100370 <panic>
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
80103976:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010397d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103980:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103982:	83 f9 00             	cmp    $0x0,%ecx
80103985:	7e 39                	jle    801039c0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103987:	83 ec 04             	sub    $0x4,%esp
8010398a:	01 c1                	add    %eax,%ecx
8010398c:	51                   	push   %ecx
8010398d:	50                   	push   %eax
8010398e:	ff 72 04             	pushl  0x4(%edx)
80103991:	e8 ba 32 00 00       	call   80106c50 <allocuvm>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	85 c0                	test   %eax,%eax
8010399b:	74 3b                	je     801039d8 <growproc+0x68>
8010399d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801039a4:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801039a6:	83 ec 0c             	sub    $0xc,%esp
801039a9:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
801039b0:	e8 8b 30 00 00       	call   80106a40 <switchuvm>
  return 0;
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	31 c0                	xor    %eax,%eax
}
801039ba:	c9                   	leave  
801039bb:	c3                   	ret    
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039c0:	74 e2                	je     801039a4 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801039c2:	83 ec 04             	sub    $0x4,%esp
801039c5:	01 c1                	add    %eax,%ecx
801039c7:	51                   	push   %ecx
801039c8:	50                   	push   %eax
801039c9:	ff 72 04             	pushl  0x4(%edx)
801039cc:	e8 7f 33 00 00       	call   80106d50 <deallocuvm>
801039d1:	83 c4 10             	add    $0x10,%esp
801039d4:	85 c0                	test   %eax,%eax
801039d6:	75 c5                	jne    8010399d <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
801039d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
801039dd:	c9                   	leave  
801039de:	c3                   	ret    
801039df:	90                   	nop

801039e0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
801039e9:	e8 52 fd ff ff       	call   80103740 <allocproc>
801039ee:	85 c0                	test   %eax,%eax
801039f0:	0f 84 d6 00 00 00    	je     80103acc <fork+0xec>
801039f6:	89 c3                	mov    %eax,%ebx
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801039f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039fe:	83 ec 08             	sub    $0x8,%esp
80103a01:	ff 30                	pushl  (%eax)
80103a03:	ff 70 04             	pushl  0x4(%eax)
80103a06:	e8 25 34 00 00       	call   80106e30 <copyuvm>
80103a0b:	83 c4 10             	add    $0x10,%esp
80103a0e:	85 c0                	test   %eax,%eax
80103a10:	89 43 04             	mov    %eax,0x4(%ebx)
80103a13:	0f 84 ba 00 00 00    	je     80103ad3 <fork+0xf3>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a1f:	8b 7b 18             	mov    0x18(%ebx),%edi
80103a22:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a27:	8b 00                	mov    (%eax),%eax
80103a29:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a31:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103a34:	8b 70 18             	mov    0x18(%eax),%esi
80103a37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a39:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a45:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103a50:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a54:	85 c0                	test   %eax,%eax
80103a56:	74 17                	je     80103a6f <fork+0x8f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103a58:	83 ec 0c             	sub    $0xc,%esp
80103a5b:	50                   	push   %eax
80103a5c:	e8 5f d3 ff ff       	call   80100dc0 <filedup>
80103a61:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103a65:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a6c:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a6f:	83 c6 01             	add    $0x1,%esi
80103a72:	83 fe 10             	cmp    $0x10,%esi
80103a75:	75 d9                	jne    80103a50 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103a77:	83 ec 0c             	sub    $0xc,%esp
80103a7a:	ff 72 68             	pushl  0x68(%edx)
80103a7d:	e8 9e db ff ff       	call   80101620 <idup>
80103a82:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a8b:	83 c4 0c             	add    $0xc,%esp
80103a8e:	6a 10                	push   $0x10
80103a90:	83 c0 6c             	add    $0x6c,%eax
80103a93:	50                   	push   %eax
80103a94:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a97:	50                   	push   %eax
80103a98:	e8 33 0c 00 00       	call   801046d0 <safestrcpy>

  pid = np->pid;
80103a9d:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103aa0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aa7:	e8 f4 07 00 00       	call   801042a0 <acquire>

  np->state = RUNNABLE;
80103aac:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103ab3:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aba:	e8 c1 09 00 00       	call   80104480 <release>

  return pid;
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	89 f0                	mov    %esi,%eax
}
80103ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ac7:	5b                   	pop    %ebx
80103ac8:	5e                   	pop    %esi
80103ac9:	5f                   	pop    %edi
80103aca:	5d                   	pop    %ebp
80103acb:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103acc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ad1:	eb f1                	jmp    80103ac4 <fork+0xe4>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103ad3:	83 ec 0c             	sub    $0xc,%esp
80103ad6:	ff 73 08             	pushl  0x8(%ebx)
80103ad9:	e8 e2 e7 ff ff       	call   801022c0 <kfree>
    np->kstack = 0;
80103ade:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ae5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103aec:	83 c4 10             	add    $0x10,%esp
80103aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103af4:	eb ce                	jmp    80103ac4 <fork+0xe4>
80103af6:	8d 76 00             	lea    0x0(%esi),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 04             	sub    $0x4,%esp
80103b07:	89 f6                	mov    %esi,%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b10:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b14:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b19:	68 a0 2d 11 80       	push   $0x80112da0
80103b1e:	e8 7d 07 00 00       	call   801042a0 <acquire>
80103b23:	83 c4 10             	add    $0x10,%esp
80103b26:	eb 16                	jmp    80103b3e <scheduler+0x3e>
80103b28:	90                   	nop
80103b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b30:	81 c3 00 01 00 00    	add    $0x100,%ebx
80103b36:	81 fb d4 6d 11 80    	cmp    $0x80116dd4,%ebx
80103b3c:	74 62                	je     80103ba0 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103b3e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b42:	75 ec                	jne    80103b30 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b44:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103b47:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103b4e:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b4f:	81 c3 00 01 00 00    	add    $0x100,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b55:	e8 e6 2e 00 00       	call   80106a40 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103b5a:	58                   	pop    %eax
80103b5b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b61:	c7 83 0c ff ff ff 04 	movl   $0x4,-0xf4(%ebx)
80103b68:	00 00 00 
      swtch(&cpu->scheduler, p->context);
80103b6b:	5a                   	pop    %edx
80103b6c:	ff b3 1c ff ff ff    	pushl  -0xe4(%ebx)
80103b72:	83 c0 04             	add    $0x4,%eax
80103b75:	50                   	push   %eax
80103b76:	e8 b0 0b 00 00       	call   8010472b <swtch>
      switchkvm();
80103b7b:	e8 a0 2e 00 00       	call   80106a20 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b80:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b83:	81 fb d4 6d 11 80    	cmp    $0x80116dd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b89:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103b90:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b94:	75 a8                	jne    80103b3e <scheduler+0x3e>
80103b96:	8d 76 00             	lea    0x0(%esi),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 a0 2d 11 80       	push   $0x80112da0
80103ba8:	e8 d3 08 00 00       	call   80104480 <release>

  }
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	e9 5b ff ff ff       	jmp    80103b10 <scheduler+0x10>
80103bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103bc7:	68 a0 2d 11 80       	push   $0x80112da0
80103bcc:	e8 ff 07 00 00       	call   801043d0 <holding>
80103bd1:	83 c4 10             	add    $0x10,%esp
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 4c                	je     80103c24 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103bd8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103bdf:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103be6:	75 63                	jne    80103c4b <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103be8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103bf2:	74 4a                	je     80103c3e <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf4:	9c                   	pushf  
80103bf5:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103bf6:	80 e5 02             	and    $0x2,%ch
80103bf9:	75 36                	jne    80103c31 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103bfb:	83 ec 08             	sub    $0x8,%esp
80103bfe:	83 c0 1c             	add    $0x1c,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103c01:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c07:	ff 72 04             	pushl  0x4(%edx)
80103c0a:	50                   	push   %eax
80103c0b:	e8 1b 0b 00 00       	call   8010472b <swtch>
  cpu->intena = intena;
80103c10:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c16:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103c19:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c22:	c9                   	leave  
80103c23:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	68 78 75 10 80       	push   $0x80107578
80103c2c:	e8 3f c7 ff ff       	call   80100370 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c31:	83 ec 0c             	sub    $0xc,%esp
80103c34:	68 a4 75 10 80       	push   $0x801075a4
80103c39:	e8 32 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c3e:	83 ec 0c             	sub    $0xc,%esp
80103c41:	68 96 75 10 80       	push   $0x80107596
80103c46:	e8 25 c7 ff ff       	call   80100370 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103c4b:	83 ec 0c             	sub    $0xc,%esp
80103c4e:	68 8a 75 10 80       	push   $0x8010758a
80103c53:	e8 18 c7 ff ff       	call   80100370 <panic>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c60:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c67:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c6d:	55                   	push   %ebp
80103c6e:	89 e5                	mov    %esp,%ebp
80103c70:	56                   	push   %esi
80103c71:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c72:	0f 84 29 01 00 00    	je     80103da1 <exit+0x141>
80103c78:	31 db                	xor    %ebx,%ebx
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103c80:	8d 73 08             	lea    0x8(%ebx),%esi
80103c83:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c87:	85 c0                	test   %eax,%eax
80103c89:	74 1b                	je     80103ca6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103c8b:	83 ec 0c             	sub    $0xc,%esp
80103c8e:	50                   	push   %eax
80103c8f:	e8 7c d1 ff ff       	call   80100e10 <fileclose>
      proc->ofile[fd] = 0;
80103c94:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103ca5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ca6:	83 c3 01             	add    $0x1,%ebx
80103ca9:	83 fb 10             	cmp    $0x10,%ebx
80103cac:	75 d2                	jne    80103c80 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cae:	e8 fd ee ff ff       	call   80102bb0 <begin_op>
  iput(proc->cwd);
80103cb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cb9:	83 ec 0c             	sub    $0xc,%esp
80103cbc:	ff 70 68             	pushl  0x68(%eax)
80103cbf:	e8 bc da ff ff       	call   80101780 <iput>
  end_op();
80103cc4:	e8 57 ef ff ff       	call   80102c20 <end_op>
  proc->cwd = 0;
80103cc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ccf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103cd6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cdd:	e8 be 05 00 00       	call   801042a0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103ce2:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103ce9:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cec:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103cf1:	8b 51 14             	mov    0x14(%ecx),%edx
80103cf4:	eb 16                	jmp    80103d0c <exit+0xac>
80103cf6:	8d 76 00             	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d00:	05 00 01 00 00       	add    $0x100,%eax
80103d05:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
80103d0a:	74 1e                	je     80103d2a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80103d0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d10:	75 ee                	jne    80103d00 <exit+0xa0>
80103d12:	3b 50 20             	cmp    0x20(%eax),%edx
80103d15:	75 e9                	jne    80103d00 <exit+0xa0>
      p->state = RUNNABLE;
80103d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d1e:	05 00 01 00 00       	add    $0x100,%eax
80103d23:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
80103d28:	75 e2                	jne    80103d0c <exit+0xac>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d2a:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d30:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103d35:	eb 17                	jmp    80103d4e <exit+0xee>
80103d37:	89 f6                	mov    %esi,%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d40:	81 c2 00 01 00 00    	add    $0x100,%edx
80103d46:	81 fa d4 6d 11 80    	cmp    $0x80116dd4,%edx
80103d4c:	74 3a                	je     80103d88 <exit+0x128>
    if(p->parent == proc){
80103d4e:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d51:	75 ed                	jne    80103d40 <exit+0xe0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d53:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d57:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d5a:	75 e4                	jne    80103d40 <exit+0xe0>
80103d5c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103d61:	eb 11                	jmp    80103d74 <exit+0x114>
80103d63:	90                   	nop
80103d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d68:	05 00 01 00 00       	add    $0x100,%eax
80103d6d:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
80103d72:	74 cc                	je     80103d40 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103d74:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d78:	75 ee                	jne    80103d68 <exit+0x108>
80103d7a:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d7d:	75 e9                	jne    80103d68 <exit+0x108>
      p->state = RUNNABLE;
80103d7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d86:	eb e0                	jmp    80103d68 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103d88:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103d8f:	e8 2c fe ff ff       	call   80103bc0 <sched>
  panic("zombie exit");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 c5 75 10 80       	push   $0x801075c5
80103d9c:	e8 cf c5 ff ff       	call   80100370 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103da1:	83 ec 0c             	sub    $0xc,%esp
80103da4:	68 b8 75 10 80       	push   $0x801075b8
80103da9:	e8 c2 c5 ff ff       	call   80100370 <panic>
80103dae:	66 90                	xchg   %ax,%ax

80103db0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103db6:	68 a0 2d 11 80       	push   $0x80112da0
80103dbb:	e8 e0 04 00 00       	call   801042a0 <acquire>
  proc->state = RUNNABLE;
80103dc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dc6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103dcd:	e8 ee fd ff ff       	call   80103bc0 <sched>
  release(&ptable.lock);
80103dd2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103dd9:	e8 a2 06 00 00       	call   80104480 <release>
}
80103dde:	83 c4 10             	add    $0x10,%esp
80103de1:	c9                   	leave  
80103de2:	c3                   	ret    
80103de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103df0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103df6:	55                   	push   %ebp
80103df7:	89 e5                	mov    %esp,%ebp
80103df9:	56                   	push   %esi
80103dfa:	53                   	push   %ebx
  if(proc == 0)
80103dfb:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103dfd:	8b 75 08             	mov    0x8(%ebp),%esi
80103e00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e03:	0f 84 97 00 00 00    	je     80103ea0 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103e09:	85 db                	test   %ebx,%ebx
80103e0b:	0f 84 82 00 00 00    	je     80103e93 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e11:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103e17:	74 57                	je     80103e70 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e19:	83 ec 0c             	sub    $0xc,%esp
80103e1c:	68 a0 2d 11 80       	push   $0x80112da0
80103e21:	e8 7a 04 00 00       	call   801042a0 <acquire>
    release(lk);
80103e26:	89 1c 24             	mov    %ebx,(%esp)
80103e29:	e8 52 06 00 00       	call   80104480 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e34:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e37:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e3e:	e8 7d fd ff ff       	call   80103bc0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e49:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e50:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e57:	e8 24 06 00 00       	call   80104480 <release>
    acquire(lk);
80103e5c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e5f:	83 c4 10             	add    $0x10,%esp
  }
}
80103e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e65:	5b                   	pop    %ebx
80103e66:	5e                   	pop    %esi
80103e67:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e68:	e9 33 04 00 00       	jmp    801042a0 <acquire>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103e70:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e7a:	e8 41 fd ff ff       	call   80103bc0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e85:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e8f:	5b                   	pop    %ebx
80103e90:	5e                   	pop    %esi
80103e91:	5d                   	pop    %ebp
80103e92:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	68 d7 75 10 80       	push   $0x801075d7
80103e9b:	e8 d0 c4 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 d1 75 10 80       	push   $0x801075d1
80103ea8:	e8 c3 c4 ff ff       	call   80100370 <panic>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi

80103eb0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103eb5:	83 ec 0c             	sub    $0xc,%esp
80103eb8:	68 a0 2d 11 80       	push   $0x80112da0
80103ebd:	e8 de 03 00 00       	call   801042a0 <acquire>
80103ec2:	83 c4 10             	add    $0x10,%esp
80103ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ecb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecd:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103ed2:	eb 12                	jmp    80103ee6 <wait+0x36>
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	81 c3 00 01 00 00    	add    $0x100,%ebx
80103ede:	81 fb d4 6d 11 80    	cmp    $0x80116dd4,%ebx
80103ee4:	74 22                	je     80103f08 <wait+0x58>
      if(p->parent != proc)
80103ee6:	3b 43 14             	cmp    0x14(%ebx),%eax
80103ee9:	75 ed                	jne    80103ed8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103eeb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eef:	74 35                	je     80103f26 <wait+0x76>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef1:	81 c3 00 01 00 00    	add    $0x100,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103ef7:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	81 fb d4 6d 11 80    	cmp    $0x80116dd4,%ebx
80103f02:	75 e2                	jne    80103ee6 <wait+0x36>
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f08:	85 d2                	test   %edx,%edx
80103f0a:	74 70                	je     80103f7c <wait+0xcc>
80103f0c:	8b 50 24             	mov    0x24(%eax),%edx
80103f0f:	85 d2                	test   %edx,%edx
80103f11:	75 69                	jne    80103f7c <wait+0xcc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f13:	83 ec 08             	sub    $0x8,%esp
80103f16:	68 a0 2d 11 80       	push   $0x80112da0
80103f1b:	50                   	push   %eax
80103f1c:	e8 cf fe ff ff       	call   80103df0 <sleep>
  }
80103f21:	83 c4 10             	add    $0x10,%esp
80103f24:	eb 9f                	jmp    80103ec5 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f2c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f2f:	e8 8c e3 ff ff       	call   801022c0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f34:	59                   	pop    %ecx
80103f35:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f38:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f3f:	e8 3c 2e 00 00       	call   80106d80 <freevm>
        p->pid = 0;
80103f44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f64:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f6b:	e8 10 05 00 00       	call   80104480 <release>
        return pid;
80103f70:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f76:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f78:	5b                   	pop    %ebx
80103f79:	5e                   	pop    %esi
80103f7a:	5d                   	pop    %ebp
80103f7b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103f7c:	83 ec 0c             	sub    $0xc,%esp
80103f7f:	68 a0 2d 11 80       	push   $0x80112da0
80103f84:	e8 f7 04 00 00       	call   80104480 <release>
      return -1;
80103f89:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f94:	5b                   	pop    %ebx
80103f95:	5e                   	pop    %esi
80103f96:	5d                   	pop    %ebp
80103f97:	c3                   	ret    
80103f98:	90                   	nop
80103f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	68 a0 2d 11 80       	push   $0x80112da0
80103faf:	e8 ec 02 00 00       	call   801042a0 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb7:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103fbc:	eb 0e                	jmp    80103fcc <wakeup+0x2c>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	05 00 01 00 00       	add    $0x100,%eax
80103fc5:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
80103fca:	74 1e                	je     80103fea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103fcc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fd0:	75 ee                	jne    80103fc0 <wakeup+0x20>
80103fd2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd5:	75 e9                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fde:	05 00 01 00 00       	add    $0x100,%eax
80103fe3:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
80103fe8:	75 e2                	jne    80103fcc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fea:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff5:	e9 86 04 00 00       	jmp    80104480 <release>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010400a:	68 a0 2d 11 80       	push   $0x80112da0
8010400f:	e8 8c 02 00 00       	call   801042a0 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010401c:	eb 0e                	jmp    8010402c <kill+0x2c>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	05 00 01 00 00       	add    $0x100,%eax
80104025:	3d d4 6d 11 80       	cmp    $0x80116dd4,%eax
8010402a:	74 3c                	je     80104068 <kill+0x68>
    if(p->pid == pid){
8010402c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010402f:	75 ef                	jne    80104020 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104031:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104035:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403c:	74 1a                	je     80104058 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 a0 2d 11 80       	push   $0x80112da0
80104046:	e8 35 04 00 00       	call   80104480 <release>
      return 0;
8010404b:	83 c4 10             	add    $0x10,%esp
8010404e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104053:	c9                   	leave  
80104054:	c3                   	ret    
80104055:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104058:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010405f:	eb dd                	jmp    8010403e <kill+0x3e>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 a0 2d 11 80       	push   $0x80112da0
80104070:	e8 0b 04 00 00       	call   80104480 <release>
  return -1;
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
80104081:	c3                   	ret    
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104099:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 27                	jmp    801040ca <procdump+0x3a>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 26 75 10 80       	push   $0x80107526
801040b0:	e8 ab c5 ff ff       	call   80100660 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	81 c3 00 01 00 00    	add    $0x100,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040be:	81 fb 40 6e 11 80    	cmp    $0x80116e40,%ebx
801040c4:	0f 84 7e 00 00 00    	je     80104148 <procdump+0xb8>
    if(p->state == UNUSED)
801040ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040cd:	85 c0                	test   %eax,%eax
801040cf:	74 e7                	je     801040b8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040d4:	ba e8 75 10 80       	mov    $0x801075e8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d9:	77 11                	ja     801040ec <procdump+0x5c>
801040db:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040e2:	b8 e8 75 10 80       	mov    $0x801075e8,%eax
801040e7:	85 d2                	test   %edx,%edx
801040e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040ec:	53                   	push   %ebx
801040ed:	52                   	push   %edx
801040ee:	ff 73 a4             	pushl  -0x5c(%ebx)
801040f1:	68 ec 75 10 80       	push   $0x801075ec
801040f6:	e8 65 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040fb:	83 c4 10             	add    $0x10,%esp
801040fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104102:	75 a4                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104104:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104107:	83 ec 08             	sub    $0x8,%esp
8010410a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010410d:	50                   	push   %eax
8010410e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104111:	8b 40 0c             	mov    0xc(%eax),%eax
80104114:	83 c0 08             	add    $0x8,%eax
80104117:	50                   	push   %eax
80104118:	e8 53 02 00 00       	call   80104370 <getcallerpcs>
8010411d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104120:	8b 17                	mov    (%edi),%edx
80104122:	85 d2                	test   %edx,%edx
80104124:	74 82                	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104126:	83 ec 08             	sub    $0x8,%esp
80104129:	83 c7 04             	add    $0x4,%edi
8010412c:	52                   	push   %edx
8010412d:	68 49 70 10 80       	push   $0x80107049
80104132:	e8 29 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	39 f7                	cmp    %esi,%edi
8010413c:	75 e2                	jne    80104120 <procdump+0x90>
8010413e:	e9 65 ff ff ff       	jmp    801040a8 <procdump+0x18>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    

80104150 <signal>:


sighandler_t signal(int signum, sighandler_t handler){
80104150:	55                   	push   %ebp
80104151:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104157:	89 e5                	mov    %esp,%ebp
80104159:	8b 55 08             	mov    0x8(%ebp),%edx
    sighandler_t old_handler=proc->sig_handler_arr[signum];
    proc->sig_handler_arr[signum]=handler;
8010415c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010415f:	8d 14 90             	lea    (%eax,%edx,4),%edx
  }
}


sighandler_t signal(int signum, sighandler_t handler){
    sighandler_t old_handler=proc->sig_handler_arr[signum];
80104162:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
    proc->sig_handler_arr[signum]=handler;
80104168:	89 8a 80 00 00 00    	mov    %ecx,0x80(%edx)
  return old_handler;

}
8010416e:	5d                   	pop    %ebp
8010416f:	c3                   	ret    

80104170 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010417a:	68 38 76 10 80       	push   $0x80107638
8010417f:	8d 43 04             	lea    0x4(%ebx),%eax
80104182:	50                   	push   %eax
80104183:	e8 f8 00 00 00       	call   80104280 <initlock>
  lk->name = name;
80104188:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010418b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104191:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104194:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010419b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010419e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a1:	c9                   	leave  
801041a2:	c3                   	ret    
801041a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	56                   	push   %esi
801041bf:	e8 dc 00 00 00       	call   801042a0 <acquire>
  while (lk->locked) {
801041c4:	8b 13                	mov    (%ebx),%edx
801041c6:	83 c4 10             	add    $0x10,%esp
801041c9:	85 d2                	test   %edx,%edx
801041cb:	74 16                	je     801041e3 <acquiresleep+0x33>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041d0:	83 ec 08             	sub    $0x8,%esp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
801041d5:	e8 16 fc ff ff       	call   80103df0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041da:	8b 03                	mov    (%ebx),%eax
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	85 c0                	test   %eax,%eax
801041e1:	75 ed                	jne    801041d0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801041e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041ef:	8b 40 10             	mov    0x10(%eax),%eax
801041f2:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041f5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041fb:	5b                   	pop    %ebx
801041fc:	5e                   	pop    %esi
801041fd:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801041fe:	e9 7d 02 00 00       	jmp    80104480 <release>
80104203:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	8d 73 04             	lea    0x4(%ebx),%esi
8010421e:	56                   	push   %esi
8010421f:	e8 7c 00 00 00       	call   801042a0 <acquire>
  lk->locked = 0;
80104224:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010422a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104231:	89 1c 24             	mov    %ebx,(%esp)
80104234:	e8 67 fd ff ff       	call   80103fa0 <wakeup>
  release(&lk->lk);
80104239:	89 75 08             	mov    %esi,0x8(%ebp)
8010423c:	83 c4 10             	add    $0x10,%esp
}
8010423f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104242:	5b                   	pop    %ebx
80104243:	5e                   	pop    %esi
80104244:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104245:	e9 36 02 00 00       	jmp    80104480 <release>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010425e:	53                   	push   %ebx
8010425f:	e8 3c 00 00 00       	call   801042a0 <acquire>
  r = lk->locked;
80104264:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104266:	89 1c 24             	mov    %ebx,(%esp)
80104269:	e8 12 02 00 00       	call   80104480 <release>
  return r;
}
8010426e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104271:	89 f0                	mov    %esi,%eax
80104273:	5b                   	pop    %ebx
80104274:	5e                   	pop    %esi
80104275:	5d                   	pop    %ebp
80104276:	c3                   	ret    
80104277:	66 90                	xchg   %ax,%ax
80104279:	66 90                	xchg   %ax,%ax
8010427b:	66 90                	xchg   %ax,%ax
8010427d:	66 90                	xchg   %ax,%ax
8010427f:	90                   	nop

80104280 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104286:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010428f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104292:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104299:	5d                   	pop    %ebp
8010429a:	c3                   	ret    
8010429b:	90                   	nop
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042a0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
801042a7:	9c                   	pushf  
801042a8:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042a9:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042aa:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801042b1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801042b7:	85 c0                	test   %eax,%eax
801042b9:	75 0c                	jne    801042c7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801042bb:	81 e2 00 02 00 00    	and    $0x200,%edx
801042c1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042c7:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
801042ca:	83 c0 01             	add    $0x1,%eax
801042cd:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801042d3:	8b 02                	mov    (%edx),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	74 05                	je     801042de <acquire+0x3e>
801042d9:	39 4a 08             	cmp    %ecx,0x8(%edx)
801042dc:	74 7a                	je     80104358 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801042de:	b9 01 00 00 00       	mov    $0x1,%ecx
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	89 c8                	mov    %ecx,%eax
801042ea:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042ed:	85 c0                	test   %eax,%eax
801042ef:	75 f7                	jne    801042e8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801042f1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801042f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801042ff:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104301:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104304:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104307:	31 c0                	xor    %eax,%eax
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104310:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104316:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010431c:	77 1a                	ja     80104338 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010431e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104321:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104324:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104327:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104329:	83 f8 0a             	cmp    $0xa,%eax
8010432c:	75 e2                	jne    80104310 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
8010432e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104331:	c9                   	leave  
80104332:	c3                   	ret    
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104338:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010433f:	83 c0 01             	add    $0x1,%eax
80104342:	83 f8 0a             	cmp    $0xa,%eax
80104345:	74 e7                	je     8010432e <acquire+0x8e>
    pcs[i] = 0;
80104347:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010434e:	83 c0 01             	add    $0x1,%eax
80104351:	83 f8 0a             	cmp    $0xa,%eax
80104354:	75 e2                	jne    80104338 <acquire+0x98>
80104356:	eb d6                	jmp    8010432e <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 43 76 10 80       	push   $0x80107643
80104360:	e8 0b c0 ff ff       	call   80100370 <panic>
80104365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104374:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010437a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010437d:	31 c0                	xor    %eax,%eax
8010437f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104380:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104386:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010438c:	77 1a                	ja     801043a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010438e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104391:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104394:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104397:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104399:	83 f8 0a             	cmp    $0xa,%eax
8010439c:	75 e2                	jne    80104380 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010439e:	5b                   	pop    %ebx
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043af:	83 c0 01             	add    $0x1,%eax
801043b2:	83 f8 0a             	cmp    $0xa,%eax
801043b5:	74 e7                	je     8010439e <getcallerpcs+0x2e>
    pcs[i] = 0;
801043b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043be:	83 c0 01             	add    $0x1,%eax
801043c1:	83 f8 0a             	cmp    $0xa,%eax
801043c4:	75 e2                	jne    801043a8 <getcallerpcs+0x38>
801043c6:	eb d6                	jmp    8010439e <getcallerpcs+0x2e>
801043c8:	90                   	nop
801043c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801043d6:	8b 02                	mov    (%edx),%eax
801043d8:	85 c0                	test   %eax,%eax
801043da:	74 14                	je     801043f0 <holding+0x20>
801043dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801043e2:	39 42 08             	cmp    %eax,0x8(%edx)
}
801043e5:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801043e6:	0f 94 c0             	sete   %al
801043e9:	0f b6 c0             	movzbl %al,%eax
}
801043ec:	c3                   	ret    
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
801043f0:	31 c0                	xor    %eax,%eax
801043f2:	5d                   	pop    %ebp
801043f3:	c3                   	ret    
801043f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104400 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104403:	9c                   	pushf  
80104404:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104405:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104406:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010440d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104413:	85 c0                	test   %eax,%eax
80104415:	75 0c                	jne    80104423 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104417:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010441d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104423:	83 c0 01             	add    $0x1,%eax
80104426:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
8010442c:	5d                   	pop    %ebp
8010442d:	c3                   	ret    
8010442e:	66 90                	xchg   %ax,%ax

80104430 <popcli>:

void
popcli(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104436:	9c                   	pushf  
80104437:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104438:	f6 c4 02             	test   $0x2,%ah
8010443b:	75 2c                	jne    80104469 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010443d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104444:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010444b:	78 0f                	js     8010445c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010444d:	75 0b                	jne    8010445a <popcli+0x2a>
8010444f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104455:	85 c0                	test   %eax,%eax
80104457:	74 01                	je     8010445a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104459:	fb                   	sti    
    sti();
}
8010445a:	c9                   	leave  
8010445b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010445c:	83 ec 0c             	sub    $0xc,%esp
8010445f:	68 62 76 10 80       	push   $0x80107662
80104464:	e8 07 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 4b 76 10 80       	push   $0x8010764b
80104471:	e8 fa be ff ff       	call   80100370 <panic>
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	83 ec 08             	sub    $0x8,%esp
80104486:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104489:	8b 10                	mov    (%eax),%edx
8010448b:	85 d2                	test   %edx,%edx
8010448d:	74 0c                	je     8010449b <release+0x1b>
8010448f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104496:	39 50 08             	cmp    %edx,0x8(%eax)
80104499:	74 15                	je     801044b0 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	68 69 76 10 80       	push   $0x80107669
801044a3:	e8 c8 be ff ff       	call   80100370 <panic>
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
801044b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801044b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801044be:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801044c9:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044ca:	e9 61 ff ff ff       	jmp    80104430 <popcli>
801044cf:	90                   	nop

801044d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	53                   	push   %ebx
801044d5:	8b 55 08             	mov    0x8(%ebp),%edx
801044d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044db:	f6 c2 03             	test   $0x3,%dl
801044de:	75 05                	jne    801044e5 <memset+0x15>
801044e0:	f6 c1 03             	test   $0x3,%cl
801044e3:	74 13                	je     801044f8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044e5:	89 d7                	mov    %edx,%edi
801044e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ea:	fc                   	cld    
801044eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044ed:	5b                   	pop    %ebx
801044ee:	89 d0                	mov    %edx,%eax
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret    
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044fc:	c1 e9 02             	shr    $0x2,%ecx
801044ff:	89 fb                	mov    %edi,%ebx
80104501:	89 f8                	mov    %edi,%eax
80104503:	c1 e3 18             	shl    $0x18,%ebx
80104506:	c1 e0 10             	shl    $0x10,%eax
80104509:	09 d8                	or     %ebx,%eax
8010450b:	09 f8                	or     %edi,%eax
8010450d:	c1 e7 08             	shl    $0x8,%edi
80104510:	09 f8                	or     %edi,%eax
80104512:	89 d7                	mov    %edx,%edi
80104514:	fc                   	cld    
80104515:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104517:	5b                   	pop    %ebx
80104518:	89 d0                	mov    %edx,%eax
8010451a:	5f                   	pop    %edi
8010451b:	5d                   	pop    %ebp
8010451c:	c3                   	ret    
8010451d:	8d 76 00             	lea    0x0(%esi),%esi

80104520 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	8b 45 10             	mov    0x10(%ebp),%eax
80104528:	53                   	push   %ebx
80104529:	8b 75 0c             	mov    0xc(%ebp),%esi
8010452c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010452f:	85 c0                	test   %eax,%eax
80104531:	74 29                	je     8010455c <memcmp+0x3c>
    if(*s1 != *s2)
80104533:	0f b6 13             	movzbl (%ebx),%edx
80104536:	0f b6 0e             	movzbl (%esi),%ecx
80104539:	38 d1                	cmp    %dl,%cl
8010453b:	75 2b                	jne    80104568 <memcmp+0x48>
8010453d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104540:	31 c0                	xor    %eax,%eax
80104542:	eb 14                	jmp    80104558 <memcmp+0x38>
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010454d:	83 c0 01             	add    $0x1,%eax
80104550:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104554:	38 ca                	cmp    %cl,%dl
80104556:	75 10                	jne    80104568 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104558:	39 f8                	cmp    %edi,%eax
8010455a:	75 ec                	jne    80104548 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010455c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010455d:	31 c0                	xor    %eax,%eax
}
8010455f:	5e                   	pop    %esi
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret    
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104568:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010456b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010456c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010456e:	5e                   	pop    %esi
8010456f:	5f                   	pop    %edi
80104570:	5d                   	pop    %ebp
80104571:	c3                   	ret    
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 45 08             	mov    0x8(%ebp),%eax
80104588:	8b 75 0c             	mov    0xc(%ebp),%esi
8010458b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010458e:	39 c6                	cmp    %eax,%esi
80104590:	73 2e                	jae    801045c0 <memmove+0x40>
80104592:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104595:	39 c8                	cmp    %ecx,%eax
80104597:	73 27                	jae    801045c0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104599:	85 db                	test   %ebx,%ebx
8010459b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010459e:	74 17                	je     801045b7 <memmove+0x37>
      *--d = *--s;
801045a0:	29 d9                	sub    %ebx,%ecx
801045a2:	89 cb                	mov    %ecx,%ebx
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801045af:	83 ea 01             	sub    $0x1,%edx
801045b2:	83 fa ff             	cmp    $0xffffffff,%edx
801045b5:	75 f1                	jne    801045a8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045b7:	5b                   	pop    %ebx
801045b8:	5e                   	pop    %esi
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	90                   	nop
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045c0:	31 d2                	xor    %edx,%edx
801045c2:	85 db                	test   %ebx,%ebx
801045c4:	74 f1                	je     801045b7 <memmove+0x37>
801045c6:	8d 76 00             	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045d7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045da:	39 d3                	cmp    %edx,%ebx
801045dc:	75 f2                	jne    801045d0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045de:	5b                   	pop    %ebx
801045df:	5e                   	pop    %esi
801045e0:	5d                   	pop    %ebp
801045e1:	c3                   	ret    
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045f3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045f4:	eb 8a                	jmp    80104580 <memmove>
801045f6:	8d 76 00             	lea    0x0(%esi),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104608:	53                   	push   %ebx
80104609:	8b 7d 08             	mov    0x8(%ebp),%edi
8010460c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010460f:	85 c9                	test   %ecx,%ecx
80104611:	74 37                	je     8010464a <strncmp+0x4a>
80104613:	0f b6 17             	movzbl (%edi),%edx
80104616:	0f b6 1e             	movzbl (%esi),%ebx
80104619:	84 d2                	test   %dl,%dl
8010461b:	74 3f                	je     8010465c <strncmp+0x5c>
8010461d:	38 d3                	cmp    %dl,%bl
8010461f:	75 3b                	jne    8010465c <strncmp+0x5c>
80104621:	8d 47 01             	lea    0x1(%edi),%eax
80104624:	01 cf                	add    %ecx,%edi
80104626:	eb 1b                	jmp    80104643 <strncmp+0x43>
80104628:	90                   	nop
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104630:	0f b6 10             	movzbl (%eax),%edx
80104633:	84 d2                	test   %dl,%dl
80104635:	74 21                	je     80104658 <strncmp+0x58>
80104637:	0f b6 19             	movzbl (%ecx),%ebx
8010463a:	83 c0 01             	add    $0x1,%eax
8010463d:	89 ce                	mov    %ecx,%esi
8010463f:	38 da                	cmp    %bl,%dl
80104641:	75 19                	jne    8010465c <strncmp+0x5c>
80104643:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104645:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104648:	75 e6                	jne    80104630 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010464a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010464b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010464d:	5e                   	pop    %esi
8010464e:	5f                   	pop    %edi
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104658:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010465c:	0f b6 c2             	movzbl %dl,%eax
8010465f:	29 d8                	sub    %ebx,%eax
}
80104661:	5b                   	pop    %ebx
80104662:	5e                   	pop    %esi
80104663:	5f                   	pop    %edi
80104664:	5d                   	pop    %ebp
80104665:	c3                   	ret    
80104666:	8d 76 00             	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 45 08             	mov    0x8(%ebp),%eax
80104678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010467b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010467e:	89 c2                	mov    %eax,%edx
80104680:	eb 19                	jmp    8010469b <strncpy+0x2b>
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104688:	83 c3 01             	add    $0x1,%ebx
8010468b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010468f:	83 c2 01             	add    $0x1,%edx
80104692:	84 c9                	test   %cl,%cl
80104694:	88 4a ff             	mov    %cl,-0x1(%edx)
80104697:	74 09                	je     801046a2 <strncpy+0x32>
80104699:	89 f1                	mov    %esi,%ecx
8010469b:	85 c9                	test   %ecx,%ecx
8010469d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046a0:	7f e6                	jg     80104688 <strncpy+0x18>
    ;
  while(n-- > 0)
801046a2:	31 c9                	xor    %ecx,%ecx
801046a4:	85 f6                	test   %esi,%esi
801046a6:	7e 17                	jle    801046bf <strncpy+0x4f>
801046a8:	90                   	nop
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046b4:	89 f3                	mov    %esi,%ebx
801046b6:	83 c1 01             	add    $0x1,%ecx
801046b9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046bb:	85 db                	test   %ebx,%ebx
801046bd:	7f f1                	jg     801046b0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046bf:	5b                   	pop    %ebx
801046c0:	5e                   	pop    %esi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046d8:	8b 45 08             	mov    0x8(%ebp),%eax
801046db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046de:	85 c9                	test   %ecx,%ecx
801046e0:	7e 26                	jle    80104708 <safestrcpy+0x38>
801046e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046e6:	89 c1                	mov    %eax,%ecx
801046e8:	eb 17                	jmp    80104701 <safestrcpy+0x31>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046f0:	83 c2 01             	add    $0x1,%edx
801046f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046f7:	83 c1 01             	add    $0x1,%ecx
801046fa:	84 db                	test   %bl,%bl
801046fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046ff:	74 04                	je     80104705 <safestrcpy+0x35>
80104701:	39 f2                	cmp    %esi,%edx
80104703:	75 eb                	jne    801046f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104705:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104708:	5b                   	pop    %ebx
80104709:	5e                   	pop    %esi
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <strlen>:

int
strlen(const char *s)
{
80104710:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104711:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104713:	89 e5                	mov    %esp,%ebp
80104715:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104718:	80 3a 00             	cmpb   $0x0,(%edx)
8010471b:	74 0c                	je     80104729 <strlen+0x19>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	83 c0 01             	add    $0x1,%eax
80104723:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104727:	75 f7                	jne    80104720 <strlen+0x10>
    ;
  return n;
}
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    

8010472b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010472b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010472f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104733:	55                   	push   %ebp
  pushl %ebx
80104734:	53                   	push   %ebx
  pushl %esi
80104735:	56                   	push   %esi
  pushl %edi
80104736:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104737:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104739:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010473b:	5f                   	pop    %edi
  popl %esi
8010473c:	5e                   	pop    %esi
  popl %ebx
8010473d:	5b                   	pop    %ebx
  popl %ebp
8010473e:	5d                   	pop    %ebp
  ret
8010473f:	c3                   	ret    

80104740 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104740:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104741:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104748:	89 e5                	mov    %esp,%ebp
8010474a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010474d:	8b 12                	mov    (%edx),%edx
8010474f:	39 c2                	cmp    %eax,%edx
80104751:	76 15                	jbe    80104768 <fetchint+0x28>
80104753:	8d 48 04             	lea    0x4(%eax),%ecx
80104756:	39 ca                	cmp    %ecx,%edx
80104758:	72 0e                	jb     80104768 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010475a:	8b 10                	mov    (%eax),%edx
8010475c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475f:	89 10                	mov    %edx,(%eax)
  return 0;
80104761:	31 c0                	xor    %eax,%eax
}
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    
80104765:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010476d:	5d                   	pop    %ebp
8010476e:	c3                   	ret    
8010476f:	90                   	nop

80104770 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104770:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104771:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104777:	89 e5                	mov    %esp,%ebp
80104779:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010477c:	39 08                	cmp    %ecx,(%eax)
8010477e:	76 2c                	jbe    801047ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104780:	8b 55 0c             	mov    0xc(%ebp),%edx
80104783:	89 c8                	mov    %ecx,%eax
80104785:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104787:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010478e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104790:	39 d1                	cmp    %edx,%ecx
80104792:	73 18                	jae    801047ac <fetchstr+0x3c>
    if(*s == 0)
80104794:	80 39 00             	cmpb   $0x0,(%ecx)
80104797:	75 0c                	jne    801047a5 <fetchstr+0x35>
80104799:	eb 1d                	jmp    801047b8 <fetchstr+0x48>
8010479b:	90                   	nop
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a0:	80 38 00             	cmpb   $0x0,(%eax)
801047a3:	74 13                	je     801047b8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801047a5:	83 c0 01             	add    $0x1,%eax
801047a8:	39 c2                	cmp    %eax,%edx
801047aa:	77 f4                	ja     801047a0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801047ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801047b8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047c7:	55                   	push   %ebp
801047c8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047ca:	8b 42 18             	mov    0x18(%edx),%eax
801047cd:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047d0:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047d2:	8b 40 44             	mov    0x44(%eax),%eax
801047d5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801047d8:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047db:	39 d1                	cmp    %edx,%ecx
801047dd:	73 19                	jae    801047f8 <argint+0x38>
801047df:	8d 48 08             	lea    0x8(%eax),%ecx
801047e2:	39 ca                	cmp    %ecx,%edx
801047e4:	72 12                	jb     801047f8 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
801047e6:	8b 50 04             	mov    0x4(%eax),%edx
801047e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ec:	89 10                	mov    %edx,(%eax)
  return 0;
801047ee:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801047f0:	5d                   	pop    %ebp
801047f1:	c3                   	ret    
801047f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801047f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801047fd:	5d                   	pop    %ebp
801047fe:	c3                   	ret    
801047ff:	90                   	nop

80104800 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104800:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104806:	55                   	push   %ebp
80104807:	89 e5                	mov    %esp,%ebp
80104809:	56                   	push   %esi
8010480a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010480b:	8b 48 18             	mov    0x18(%eax),%ecx
8010480e:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104811:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104814:	8b 49 44             	mov    0x44(%ecx),%ecx
80104817:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010481a:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
8010481c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104821:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104824:	39 ce                	cmp    %ecx,%esi
80104826:	73 1f                	jae    80104847 <argptr+0x47>
80104828:	8d 73 08             	lea    0x8(%ebx),%esi
8010482b:	39 f1                	cmp    %esi,%ecx
8010482d:	72 18                	jb     80104847 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010482f:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104831:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104834:	78 11                	js     80104847 <argptr+0x47>
80104836:	39 cb                	cmp    %ecx,%ebx
80104838:	73 0d                	jae    80104847 <argptr+0x47>
8010483a:	01 da                	add    %ebx,%edx
8010483c:	39 ca                	cmp    %ecx,%edx
8010483e:	77 07                	ja     80104847 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104840:	8b 45 0c             	mov    0xc(%ebp),%eax
80104843:	89 18                	mov    %ebx,(%eax)
  return 0;
80104845:	31 c0                	xor    %eax,%eax
}
80104847:	5b                   	pop    %ebx
80104848:	5e                   	pop    %esi
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104850:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104856:	55                   	push   %ebp
80104857:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104859:	8b 50 18             	mov    0x18(%eax),%edx
8010485c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010485f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104861:	8b 52 44             	mov    0x44(%edx),%edx
80104864:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104867:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010486a:	39 c1                	cmp    %eax,%ecx
8010486c:	73 07                	jae    80104875 <argstr+0x25>
8010486e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104871:	39 c8                	cmp    %ecx,%eax
80104873:	73 0b                	jae    80104880 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104880:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104883:	39 c1                	cmp    %eax,%ecx
80104885:	73 ee                	jae    80104875 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104887:	8b 55 0c             	mov    0xc(%ebp),%edx
8010488a:	89 c8                	mov    %ecx,%eax
8010488c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010488e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104895:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104897:	39 d1                	cmp    %edx,%ecx
80104899:	73 da                	jae    80104875 <argstr+0x25>
    if(*s == 0)
8010489b:	80 39 00             	cmpb   $0x0,(%ecx)
8010489e:	75 0d                	jne    801048ad <argstr+0x5d>
801048a0:	eb 1e                	jmp    801048c0 <argstr+0x70>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048a8:	80 38 00             	cmpb   $0x0,(%eax)
801048ab:	74 13                	je     801048c0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801048ad:	83 c0 01             	add    $0x1,%eax
801048b0:	39 c2                	cmp    %eax,%edx
801048b2:	77 f4                	ja     801048a8 <argstr+0x58>
801048b4:	eb bf                	jmp    80104875 <argstr+0x25>
801048b6:	8d 76 00             	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
801048c0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801048c2:	5d                   	pop    %ebp
801048c3:	c3                   	ret    
801048c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048d0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
801048d7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048de:	8b 5a 18             	mov    0x18(%edx),%ebx
801048e1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048e4:	8d 48 ff             	lea    -0x1(%eax),%ecx
801048e7:	83 f9 14             	cmp    $0x14,%ecx
801048ea:	77 1c                	ja     80104908 <syscall+0x38>
801048ec:	8b 0c 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%ecx
801048f3:	85 c9                	test   %ecx,%ecx
801048f5:	74 11                	je     80104908 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
801048f7:	ff d1                	call   *%ecx
801048f9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
801048fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ff:	c9                   	leave  
80104900:	c3                   	ret    
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104908:	50                   	push   %eax
            proc->pid, proc->name, num);
80104909:	8d 42 6c             	lea    0x6c(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010490c:	50                   	push   %eax
8010490d:	ff 72 10             	pushl  0x10(%edx)
80104910:	68 71 76 10 80       	push   $0x80107671
80104915:	e8 46 bd ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010491a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	8b 40 18             	mov    0x18(%eax),%eax
80104926:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010492d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104930:	c9                   	leave  
80104931:	c3                   	ret    
80104932:	66 90                	xchg   %ax,%ax
80104934:	66 90                	xchg   %ax,%ax
80104936:	66 90                	xchg   %ax,%ax
80104938:	66 90                	xchg   %ax,%ax
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104946:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104949:	83 ec 44             	sub    $0x44,%esp
8010494c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010494f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104952:	56                   	push   %esi
80104953:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104954:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104957:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010495a:	e8 41 d5 ff ff       	call   80101ea0 <nameiparent>
8010495f:	83 c4 10             	add    $0x10,%esp
80104962:	85 c0                	test   %eax,%eax
80104964:	0f 84 f6 00 00 00    	je     80104a60 <create+0x120>
    return 0;
  ilock(dp);
8010496a:	83 ec 0c             	sub    $0xc,%esp
8010496d:	89 c7                	mov    %eax,%edi
8010496f:	50                   	push   %eax
80104970:	e8 db cc ff ff       	call   80101650 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104975:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104978:	83 c4 0c             	add    $0xc,%esp
8010497b:	50                   	push   %eax
8010497c:	56                   	push   %esi
8010497d:	57                   	push   %edi
8010497e:	e8 dd d1 ff ff       	call   80101b60 <dirlookup>
80104983:	83 c4 10             	add    $0x10,%esp
80104986:	85 c0                	test   %eax,%eax
80104988:	89 c3                	mov    %eax,%ebx
8010498a:	74 54                	je     801049e0 <create+0xa0>
    iunlockput(dp);
8010498c:	83 ec 0c             	sub    $0xc,%esp
8010498f:	57                   	push   %edi
80104990:	e8 2b cf ff ff       	call   801018c0 <iunlockput>
    ilock(ip);
80104995:	89 1c 24             	mov    %ebx,(%esp)
80104998:	e8 b3 cc ff ff       	call   80101650 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010499d:	83 c4 10             	add    $0x10,%esp
801049a0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049a5:	75 19                	jne    801049c0 <create+0x80>
801049a7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801049ac:	89 d8                	mov    %ebx,%eax
801049ae:	75 10                	jne    801049c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049b3:	5b                   	pop    %ebx
801049b4:	5e                   	pop    %esi
801049b5:	5f                   	pop    %edi
801049b6:	5d                   	pop    %ebp
801049b7:	c3                   	ret    
801049b8:	90                   	nop
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	53                   	push   %ebx
801049c4:	e8 f7 ce ff ff       	call   801018c0 <iunlockput>
    return 0;
801049c9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049cf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049d1:	5b                   	pop    %ebx
801049d2:	5e                   	pop    %esi
801049d3:	5f                   	pop    %edi
801049d4:	5d                   	pop    %ebp
801049d5:	c3                   	ret    
801049d6:	8d 76 00             	lea    0x0(%esi),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049e4:	83 ec 08             	sub    $0x8,%esp
801049e7:	50                   	push   %eax
801049e8:	ff 37                	pushl  (%edi)
801049ea:	e8 f1 ca ff ff       	call   801014e0 <ialloc>
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	85 c0                	test   %eax,%eax
801049f4:	89 c3                	mov    %eax,%ebx
801049f6:	0f 84 cc 00 00 00    	je     80104ac8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801049fc:	83 ec 0c             	sub    $0xc,%esp
801049ff:	50                   	push   %eax
80104a00:	e8 4b cc ff ff       	call   80101650 <ilock>
  ip->major = major;
80104a05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a09:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104a0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a11:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104a15:	b8 01 00 00 00       	mov    $0x1,%eax
80104a1a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104a1e:	89 1c 24             	mov    %ebx,(%esp)
80104a21:	e8 7a cb ff ff       	call   801015a0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a26:	83 c4 10             	add    $0x10,%esp
80104a29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a2e:	74 40                	je     80104a70 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a30:	83 ec 04             	sub    $0x4,%esp
80104a33:	ff 73 04             	pushl  0x4(%ebx)
80104a36:	56                   	push   %esi
80104a37:	57                   	push   %edi
80104a38:	e8 83 d3 ff ff       	call   80101dc0 <dirlink>
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	85 c0                	test   %eax,%eax
80104a42:	78 77                	js     80104abb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	57                   	push   %edi
80104a48:	e8 73 ce ff ff       	call   801018c0 <iunlockput>

  return ip;
80104a4d:	83 c4 10             	add    $0x10,%esp
}
80104a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a53:	89 d8                	mov    %ebx,%eax
}
80104a55:	5b                   	pop    %ebx
80104a56:	5e                   	pop    %esi
80104a57:	5f                   	pop    %edi
80104a58:	5d                   	pop    %ebp
80104a59:	c3                   	ret    
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a60:	31 c0                	xor    %eax,%eax
80104a62:	e9 49 ff ff ff       	jmp    801049b0 <create+0x70>
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a70:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	57                   	push   %edi
80104a79:	e8 22 cb ff ff       	call   801015a0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a7e:	83 c4 0c             	add    $0xc,%esp
80104a81:	ff 73 04             	pushl  0x4(%ebx)
80104a84:	68 14 77 10 80       	push   $0x80107714
80104a89:	53                   	push   %ebx
80104a8a:	e8 31 d3 ff ff       	call   80101dc0 <dirlink>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	85 c0                	test   %eax,%eax
80104a94:	78 18                	js     80104aae <create+0x16e>
80104a96:	83 ec 04             	sub    $0x4,%esp
80104a99:	ff 77 04             	pushl  0x4(%edi)
80104a9c:	68 13 77 10 80       	push   $0x80107713
80104aa1:	53                   	push   %ebx
80104aa2:	e8 19 d3 ff ff       	call   80101dc0 <dirlink>
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	79 82                	jns    80104a30 <create+0xf0>
      panic("create dots");
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	68 07 77 10 80       	push   $0x80107707
80104ab6:	e8 b5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	68 16 77 10 80       	push   $0x80107716
80104ac3:	e8 a8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104ac8:	83 ec 0c             	sub    $0xc,%esp
80104acb:	68 f8 76 10 80       	push   $0x801076f8
80104ad0:	e8 9b b8 ff ff       	call   80100370 <panic>
80104ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
80104ae5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aea:	89 d3                	mov    %edx,%ebx
80104aec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104aef:	50                   	push   %eax
80104af0:	6a 00                	push   $0x0
80104af2:	e8 c9 fc ff ff       	call   801047c0 <argint>
80104af7:	83 c4 10             	add    $0x10,%esp
80104afa:	85 c0                	test   %eax,%eax
80104afc:	78 3a                	js     80104b38 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b01:	83 f8 0f             	cmp    $0xf,%eax
80104b04:	77 32                	ja     80104b38 <argfd.constprop.0+0x58>
80104b06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b0d:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104b11:	85 d2                	test   %edx,%edx
80104b13:	74 23                	je     80104b38 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104b15:	85 f6                	test   %esi,%esi
80104b17:	74 02                	je     80104b1b <argfd.constprop.0+0x3b>
    *pfd = fd;
80104b19:	89 06                	mov    %eax,(%esi)
  if(pf)
80104b1b:	85 db                	test   %ebx,%ebx
80104b1d:	74 11                	je     80104b30 <argfd.constprop.0+0x50>
    *pf = f;
80104b1f:	89 13                	mov    %edx,(%ebx)
  return 0;
80104b21:	31 c0                	xor    %eax,%eax
}
80104b23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b26:	5b                   	pop    %ebx
80104b27:	5e                   	pop    %esi
80104b28:	5d                   	pop    %ebp
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b30:	31 c0                	xor    %eax,%eax
80104b32:	eb ef                	jmp    80104b23 <argfd.constprop.0+0x43>
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b3d:	eb e4                	jmp    80104b23 <argfd.constprop.0+0x43>
80104b3f:	90                   	nop

80104b40 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b40:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b41:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b46:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b49:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b4c:	e8 8f ff ff ff       	call   80104ae0 <argfd.constprop.0>
80104b51:	85 c0                	test   %eax,%eax
80104b53:	78 1b                	js     80104b70 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b5e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104b60:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104b64:	85 c9                	test   %ecx,%ecx
80104b66:	74 18                	je     80104b80 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b68:	83 c3 01             	add    $0x1,%ebx
80104b6b:	83 fb 10             	cmp    $0x10,%ebx
80104b6e:	75 f0                	jne    80104b60 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b78:	c9                   	leave  
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b80:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104b83:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b87:	52                   	push   %edx
80104b88:	e8 33 c2 ff ff       	call   80100dc0 <filedup>
  return fd;
80104b8d:	89 d8                	mov    %ebx,%eax
80104b8f:	83 c4 10             	add    $0x10,%esp
}
80104b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <sys_read>:

int
sys_read(void)
{
80104ba0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bab:	e8 30 ff ff ff       	call   80104ae0 <argfd.constprop.0>
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	78 4c                	js     80104c00 <sys_read+0x60>
80104bb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bb7:	83 ec 08             	sub    $0x8,%esp
80104bba:	50                   	push   %eax
80104bbb:	6a 02                	push   $0x2
80104bbd:	e8 fe fb ff ff       	call   801047c0 <argint>
80104bc2:	83 c4 10             	add    $0x10,%esp
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	78 37                	js     80104c00 <sys_read+0x60>
80104bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcc:	83 ec 04             	sub    $0x4,%esp
80104bcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bd2:	50                   	push   %eax
80104bd3:	6a 01                	push   $0x1
80104bd5:	e8 26 fc ff ff       	call   80104800 <argptr>
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	78 1f                	js     80104c00 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104be1:	83 ec 04             	sub    $0x4,%esp
80104be4:	ff 75 f0             	pushl  -0x10(%ebp)
80104be7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bea:	ff 75 ec             	pushl  -0x14(%ebp)
80104bed:	e8 3e c3 ff ff       	call   80100f30 <fileread>
80104bf2:	83 c4 10             	add    $0x10,%esp
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <sys_write>:

int
sys_write(void)
{
80104c10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c11:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c1b:	e8 c0 fe ff ff       	call   80104ae0 <argfd.constprop.0>
80104c20:	85 c0                	test   %eax,%eax
80104c22:	78 4c                	js     80104c70 <sys_write+0x60>
80104c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c27:	83 ec 08             	sub    $0x8,%esp
80104c2a:	50                   	push   %eax
80104c2b:	6a 02                	push   $0x2
80104c2d:	e8 8e fb ff ff       	call   801047c0 <argint>
80104c32:	83 c4 10             	add    $0x10,%esp
80104c35:	85 c0                	test   %eax,%eax
80104c37:	78 37                	js     80104c70 <sys_write+0x60>
80104c39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c3c:	83 ec 04             	sub    $0x4,%esp
80104c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c42:	50                   	push   %eax
80104c43:	6a 01                	push   $0x1
80104c45:	e8 b6 fb ff ff       	call   80104800 <argptr>
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	85 c0                	test   %eax,%eax
80104c4f:	78 1f                	js     80104c70 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c51:	83 ec 04             	sub    $0x4,%esp
80104c54:	ff 75 f0             	pushl  -0x10(%ebp)
80104c57:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c5d:	e8 5e c3 ff ff       	call   80100fc0 <filewrite>
80104c62:	83 c4 10             	add    $0x10,%esp
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_close>:

int
sys_close(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c8c:	e8 4f fe ff ff       	call   80104ae0 <argfd.constprop.0>
80104c91:	85 c0                	test   %eax,%eax
80104c93:	78 2b                	js     80104cc0 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104c9e:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104ca1:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ca8:	00 
  fileclose(f);
80104ca9:	ff 75 f4             	pushl  -0xc(%ebp)
80104cac:	e8 5f c1 ff ff       	call   80100e10 <fileclose>
  return 0;
80104cb1:	83 c4 10             	add    $0x10,%esp
80104cb4:	31 c0                	xor    %eax,%eax
}
80104cb6:	c9                   	leave  
80104cb7:	c3                   	ret    
80104cb8:	90                   	nop
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_fstat>:

int
sys_fstat(void)
{
80104cd0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cdb:	e8 00 fe ff ff       	call   80104ae0 <argfd.constprop.0>
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	78 2c                	js     80104d10 <sys_fstat+0x40>
80104ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce7:	83 ec 04             	sub    $0x4,%esp
80104cea:	6a 14                	push   $0x14
80104cec:	50                   	push   %eax
80104ced:	6a 01                	push   $0x1
80104cef:	e8 0c fb ff ff       	call   80104800 <argptr>
80104cf4:	83 c4 10             	add    $0x10,%esp
80104cf7:	85 c0                	test   %eax,%eax
80104cf9:	78 15                	js     80104d10 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104cfb:	83 ec 08             	sub    $0x8,%esp
80104cfe:	ff 75 f4             	pushl  -0xc(%ebp)
80104d01:	ff 75 f0             	pushl  -0x10(%ebp)
80104d04:	e8 d7 c1 ff ff       	call   80100ee0 <filestat>
80104d09:	83 c4 10             	add    $0x10,%esp
}
80104d0c:	c9                   	leave  
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d26:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d29:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d2c:	50                   	push   %eax
80104d2d:	6a 00                	push   $0x0
80104d2f:	e8 1c fb ff ff       	call   80104850 <argstr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	0f 88 fb 00 00 00    	js     80104e3a <sys_link+0x11a>
80104d3f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d42:	83 ec 08             	sub    $0x8,%esp
80104d45:	50                   	push   %eax
80104d46:	6a 01                	push   $0x1
80104d48:	e8 03 fb ff ff       	call   80104850 <argstr>
80104d4d:	83 c4 10             	add    $0x10,%esp
80104d50:	85 c0                	test   %eax,%eax
80104d52:	0f 88 e2 00 00 00    	js     80104e3a <sys_link+0x11a>
    return -1;

  begin_op();
80104d58:	e8 53 de ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d63:	e8 18 d1 ff ff       	call   80101e80 <namei>
80104d68:	83 c4 10             	add    $0x10,%esp
80104d6b:	85 c0                	test   %eax,%eax
80104d6d:	89 c3                	mov    %eax,%ebx
80104d6f:	0f 84 f3 00 00 00    	je     80104e68 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d75:	83 ec 0c             	sub    $0xc,%esp
80104d78:	50                   	push   %eax
80104d79:	e8 d2 c8 ff ff       	call   80101650 <ilock>
  if(ip->type == T_DIR){
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d86:	0f 84 c4 00 00 00    	je     80104e50 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d8c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d91:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d94:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d97:	53                   	push   %ebx
80104d98:	e8 03 c8 ff ff       	call   801015a0 <iupdate>
  iunlock(ip);
80104d9d:	89 1c 24             	mov    %ebx,(%esp)
80104da0:	e8 8b c9 ff ff       	call   80101730 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104da5:	58                   	pop    %eax
80104da6:	5a                   	pop    %edx
80104da7:	57                   	push   %edi
80104da8:	ff 75 d0             	pushl  -0x30(%ebp)
80104dab:	e8 f0 d0 ff ff       	call   80101ea0 <nameiparent>
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	85 c0                	test   %eax,%eax
80104db5:	89 c6                	mov    %eax,%esi
80104db7:	74 5b                	je     80104e14 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104db9:	83 ec 0c             	sub    $0xc,%esp
80104dbc:	50                   	push   %eax
80104dbd:	e8 8e c8 ff ff       	call   80101650 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	8b 03                	mov    (%ebx),%eax
80104dc7:	39 06                	cmp    %eax,(%esi)
80104dc9:	75 3d                	jne    80104e08 <sys_link+0xe8>
80104dcb:	83 ec 04             	sub    $0x4,%esp
80104dce:	ff 73 04             	pushl  0x4(%ebx)
80104dd1:	57                   	push   %edi
80104dd2:	56                   	push   %esi
80104dd3:	e8 e8 cf ff ff       	call   80101dc0 <dirlink>
80104dd8:	83 c4 10             	add    $0x10,%esp
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	78 29                	js     80104e08 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	56                   	push   %esi
80104de3:	e8 d8 ca ff ff       	call   801018c0 <iunlockput>
  iput(ip);
80104de8:	89 1c 24             	mov    %ebx,(%esp)
80104deb:	e8 90 c9 ff ff       	call   80101780 <iput>

  end_op();
80104df0:	e8 2b de ff ff       	call   80102c20 <end_op>

  return 0;
80104df5:	83 c4 10             	add    $0x10,%esp
80104df8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dfd:	5b                   	pop    %ebx
80104dfe:	5e                   	pop    %esi
80104dff:	5f                   	pop    %edi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret    
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	56                   	push   %esi
80104e0c:	e8 af ca ff ff       	call   801018c0 <iunlockput>
    goto bad;
80104e11:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	53                   	push   %ebx
80104e18:	e8 33 c8 ff ff       	call   80101650 <ilock>
  ip->nlink--;
80104e1d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e22:	89 1c 24             	mov    %ebx,(%esp)
80104e25:	e8 76 c7 ff ff       	call   801015a0 <iupdate>
  iunlockput(ip);
80104e2a:	89 1c 24             	mov    %ebx,(%esp)
80104e2d:	e8 8e ca ff ff       	call   801018c0 <iunlockput>
  end_op();
80104e32:	e8 e9 dd ff ff       	call   80102c20 <end_op>
  return -1;
80104e37:	83 c4 10             	add    $0x10,%esp
}
80104e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5f                   	pop    %edi
80104e45:	5d                   	pop    %ebp
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e50:	83 ec 0c             	sub    $0xc,%esp
80104e53:	53                   	push   %ebx
80104e54:	e8 67 ca ff ff       	call   801018c0 <iunlockput>
    end_op();
80104e59:	e8 c2 dd ff ff       	call   80102c20 <end_op>
    return -1;
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e66:	eb 92                	jmp    80104dfa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e68:	e8 b3 dd ff ff       	call   80102c20 <end_op>
    return -1;
80104e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e72:	eb 86                	jmp    80104dfa <sys_link+0xda>
80104e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e80 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e86:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e89:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e8c:	50                   	push   %eax
80104e8d:	6a 00                	push   $0x0
80104e8f:	e8 bc f9 ff ff       	call   80104850 <argstr>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	0f 88 82 01 00 00    	js     80105021 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104ea2:	e8 09 dd ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ea7:	83 ec 08             	sub    $0x8,%esp
80104eaa:	53                   	push   %ebx
80104eab:	ff 75 c0             	pushl  -0x40(%ebp)
80104eae:	e8 ed cf ff ff       	call   80101ea0 <nameiparent>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ebb:	0f 84 6a 01 00 00    	je     8010502b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104ec1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	56                   	push   %esi
80104ec8:	e8 83 c7 ff ff       	call   80101650 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ecd:	58                   	pop    %eax
80104ece:	5a                   	pop    %edx
80104ecf:	68 14 77 10 80       	push   $0x80107714
80104ed4:	53                   	push   %ebx
80104ed5:	e8 66 cc ff ff       	call   80101b40 <namecmp>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	85 c0                	test   %eax,%eax
80104edf:	0f 84 fc 00 00 00    	je     80104fe1 <sys_unlink+0x161>
80104ee5:	83 ec 08             	sub    $0x8,%esp
80104ee8:	68 13 77 10 80       	push   $0x80107713
80104eed:	53                   	push   %ebx
80104eee:	e8 4d cc ff ff       	call   80101b40 <namecmp>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	0f 84 e3 00 00 00    	je     80104fe1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104efe:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f01:	83 ec 04             	sub    $0x4,%esp
80104f04:	50                   	push   %eax
80104f05:	53                   	push   %ebx
80104f06:	56                   	push   %esi
80104f07:	e8 54 cc ff ff       	call   80101b60 <dirlookup>
80104f0c:	83 c4 10             	add    $0x10,%esp
80104f0f:	85 c0                	test   %eax,%eax
80104f11:	89 c3                	mov    %eax,%ebx
80104f13:	0f 84 c8 00 00 00    	je     80104fe1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	50                   	push   %eax
80104f1d:	e8 2e c7 ff ff       	call   80101650 <ilock>

  if(ip->nlink < 1)
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f2a:	0f 8e 24 01 00 00    	jle    80105054 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f35:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f38:	74 66                	je     80104fa0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f3a:	83 ec 04             	sub    $0x4,%esp
80104f3d:	6a 10                	push   $0x10
80104f3f:	6a 00                	push   $0x0
80104f41:	56                   	push   %esi
80104f42:	e8 89 f5 ff ff       	call   801044d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f47:	6a 10                	push   $0x10
80104f49:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f4c:	56                   	push   %esi
80104f4d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f50:	e8 bb ca ff ff       	call   80101a10 <writei>
80104f55:	83 c4 20             	add    $0x20,%esp
80104f58:	83 f8 10             	cmp    $0x10,%eax
80104f5b:	0f 85 e6 00 00 00    	jne    80105047 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f66:	0f 84 9c 00 00 00    	je     80105008 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f72:	e8 49 c9 ff ff       	call   801018c0 <iunlockput>

  ip->nlink--;
80104f77:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f7c:	89 1c 24             	mov    %ebx,(%esp)
80104f7f:	e8 1c c6 ff ff       	call   801015a0 <iupdate>
  iunlockput(ip);
80104f84:	89 1c 24             	mov    %ebx,(%esp)
80104f87:	e8 34 c9 ff ff       	call   801018c0 <iunlockput>

  end_op();
80104f8c:	e8 8f dc ff ff       	call   80102c20 <end_op>

  return 0;
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5f                   	pop    %edi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fa0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fa4:	76 94                	jbe    80104f3a <sys_unlink+0xba>
80104fa6:	bf 20 00 00 00       	mov    $0x20,%edi
80104fab:	eb 0f                	jmp    80104fbc <sys_unlink+0x13c>
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
80104fb0:	83 c7 10             	add    $0x10,%edi
80104fb3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104fb6:	0f 83 7e ff ff ff    	jae    80104f3a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fbc:	6a 10                	push   $0x10
80104fbe:	57                   	push   %edi
80104fbf:	56                   	push   %esi
80104fc0:	53                   	push   %ebx
80104fc1:	e8 4a c9 ff ff       	call   80101910 <readi>
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	83 f8 10             	cmp    $0x10,%eax
80104fcc:	75 6c                	jne    8010503a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fce:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fd3:	74 db                	je     80104fb0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fd5:	83 ec 0c             	sub    $0xc,%esp
80104fd8:	53                   	push   %ebx
80104fd9:	e8 e2 c8 ff ff       	call   801018c0 <iunlockput>
    goto bad;
80104fde:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fe1:	83 ec 0c             	sub    $0xc,%esp
80104fe4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fe7:	e8 d4 c8 ff ff       	call   801018c0 <iunlockput>
  end_op();
80104fec:	e8 2f dc ff ff       	call   80102c20 <end_op>
  return -1;
80104ff1:	83 c4 10             	add    $0x10,%esp
}
80104ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ffc:	5b                   	pop    %ebx
80104ffd:	5e                   	pop    %esi
80104ffe:	5f                   	pop    %edi
80104fff:	5d                   	pop    %ebp
80105000:	c3                   	ret    
80105001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105008:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010500b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010500e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105013:	50                   	push   %eax
80105014:	e8 87 c5 ff ff       	call   801015a0 <iupdate>
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	e9 4b ff ff ff       	jmp    80104f6c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	e9 6b ff ff ff       	jmp    80104f96 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010502b:	e8 f0 db ff ff       	call   80102c20 <end_op>
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	e9 5c ff ff ff       	jmp    80104f96 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	68 38 77 10 80       	push   $0x80107738
80105042:	e8 29 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 4a 77 10 80       	push   $0x8010774a
8010504f:	e8 1c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	68 26 77 10 80       	push   $0x80107726
8010505c:	e8 0f b3 ff ff       	call   80100370 <panic>
80105061:	eb 0d                	jmp    80105070 <sys_open>
80105063:	90                   	nop
80105064:	90                   	nop
80105065:	90                   	nop
80105066:	90                   	nop
80105067:	90                   	nop
80105068:	90                   	nop
80105069:	90                   	nop
8010506a:	90                   	nop
8010506b:	90                   	nop
8010506c:	90                   	nop
8010506d:	90                   	nop
8010506e:	90                   	nop
8010506f:	90                   	nop

80105070 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105076:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105079:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 cc f7 ff ff       	call   80104850 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 9e 00 00 00    	js     8010512d <sys_open+0xbd>
8010508f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105092:	83 ec 08             	sub    $0x8,%esp
80105095:	50                   	push   %eax
80105096:	6a 01                	push   $0x1
80105098:	e8 23 f7 ff ff       	call   801047c0 <argint>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	0f 88 85 00 00 00    	js     8010512d <sys_open+0xbd>
    return -1;

  begin_op();
801050a8:	e8 03 db ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
801050ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050b1:	0f 85 89 00 00 00    	jne    80105140 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050b7:	83 ec 0c             	sub    $0xc,%esp
801050ba:	ff 75 e0             	pushl  -0x20(%ebp)
801050bd:	e8 be cd ff ff       	call   80101e80 <namei>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	89 c7                	mov    %eax,%edi
801050c9:	0f 84 8e 00 00 00    	je     8010515d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	50                   	push   %eax
801050d3:	e8 78 c5 ff ff       	call   80101650 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801050e0:	0f 84 d2 00 00 00    	je     801051b8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050e6:	e8 65 bc ff ff       	call   80100d50 <filealloc>
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c6                	mov    %eax,%esi
801050ef:	74 2b                	je     8010511c <sys_open+0xac>
801050f1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050f8:	31 db                	xor    %ebx,%ebx
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105100:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105104:	85 c0                	test   %eax,%eax
80105106:	74 68                	je     80105170 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105108:	83 c3 01             	add    $0x1,%ebx
8010510b:	83 fb 10             	cmp    $0x10,%ebx
8010510e:	75 f0                	jne    80105100 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	56                   	push   %esi
80105114:	e8 f7 bc ff ff       	call   80100e10 <fileclose>
80105119:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	57                   	push   %edi
80105120:	e8 9b c7 ff ff       	call   801018c0 <iunlockput>
    end_op();
80105125:	e8 f6 da ff ff       	call   80102c20 <end_op>
    return -1;
8010512a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010512d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105135:	5b                   	pop    %ebx
80105136:	5e                   	pop    %esi
80105137:	5f                   	pop    %edi
80105138:	5d                   	pop    %ebp
80105139:	c3                   	ret    
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105146:	31 c9                	xor    %ecx,%ecx
80105148:	6a 00                	push   $0x0
8010514a:	ba 02 00 00 00       	mov    $0x2,%edx
8010514f:	e8 ec f7 ff ff       	call   80104940 <create>
    if(ip == 0){
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105159:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010515b:	75 89                	jne    801050e6 <sys_open+0x76>
      end_op();
8010515d:	e8 be da ff ff       	call   80102c20 <end_op>
      return -1;
80105162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105167:	eb 43                	jmp    801051ac <sys_open+0x13c>
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105170:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105173:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105177:	57                   	push   %edi
80105178:	e8 b3 c5 ff ff       	call   80101730 <iunlock>
  end_op();
8010517d:	e8 9e da ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105182:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010518b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010518e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105191:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105198:	89 d0                	mov    %edx,%eax
8010519a:	83 e0 01             	and    $0x1,%eax
8010519d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051a3:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a6:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
801051aa:	89 d8                	mov    %ebx,%eax
}
801051ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051af:	5b                   	pop    %ebx
801051b0:	5e                   	pop    %esi
801051b1:	5f                   	pop    %edi
801051b2:	5d                   	pop    %ebp
801051b3:	c3                   	ret    
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801051bb:	85 d2                	test   %edx,%edx
801051bd:	0f 84 23 ff ff ff    	je     801050e6 <sys_open+0x76>
801051c3:	e9 54 ff ff ff       	jmp    8010511c <sys_open+0xac>
801051c8:	90                   	nop
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051d6:	e8 d5 d9 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051de:	83 ec 08             	sub    $0x8,%esp
801051e1:	50                   	push   %eax
801051e2:	6a 00                	push   $0x0
801051e4:	e8 67 f6 ff ff       	call   80104850 <argstr>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	85 c0                	test   %eax,%eax
801051ee:	78 30                	js     80105220 <sys_mkdir+0x50>
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f6:	31 c9                	xor    %ecx,%ecx
801051f8:	6a 00                	push   $0x0
801051fa:	ba 01 00 00 00       	mov    $0x1,%edx
801051ff:	e8 3c f7 ff ff       	call   80104940 <create>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	74 15                	je     80105220 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010520b:	83 ec 0c             	sub    $0xc,%esp
8010520e:	50                   	push   %eax
8010520f:	e8 ac c6 ff ff       	call   801018c0 <iunlockput>
  end_op();
80105214:	e8 07 da ff ff       	call   80102c20 <end_op>
  return 0;
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	31 c0                	xor    %eax,%eax
}
8010521e:	c9                   	leave  
8010521f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105220:	e8 fb d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_mknod>:

int
sys_mknod(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105236:	e8 75 d9 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010523b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010523e:	83 ec 08             	sub    $0x8,%esp
80105241:	50                   	push   %eax
80105242:	6a 00                	push   $0x0
80105244:	e8 07 f6 ff ff       	call   80104850 <argstr>
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	85 c0                	test   %eax,%eax
8010524e:	78 60                	js     801052b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105250:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105253:	83 ec 08             	sub    $0x8,%esp
80105256:	50                   	push   %eax
80105257:	6a 01                	push   $0x1
80105259:	e8 62 f5 ff ff       	call   801047c0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	85 c0                	test   %eax,%eax
80105263:	78 4b                	js     801052b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105265:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105268:	83 ec 08             	sub    $0x8,%esp
8010526b:	50                   	push   %eax
8010526c:	6a 02                	push   $0x2
8010526e:	e8 4d f5 ff ff       	call   801047c0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 36                	js     801052b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010527a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105285:	ba 03 00 00 00       	mov    $0x3,%edx
8010528a:	50                   	push   %eax
8010528b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010528e:	e8 ad f6 ff ff       	call   80104940 <create>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	74 16                	je     801052b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010529a:	83 ec 0c             	sub    $0xc,%esp
8010529d:	50                   	push   %eax
8010529e:	e8 1d c6 ff ff       	call   801018c0 <iunlockput>
  end_op();
801052a3:	e8 78 d9 ff ff       	call   80102c20 <end_op>
  return 0;
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	31 c0                	xor    %eax,%eax
}
801052ad:	c9                   	leave  
801052ae:	c3                   	ret    
801052af:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052b0:	e8 6b d9 ff ff       	call   80102c20 <end_op>
    return -1;
801052b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052ba:	c9                   	leave  
801052bb:	c3                   	ret    
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_chdir>:

int
sys_chdir(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052c7:	e8 e4 d8 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cf:	83 ec 08             	sub    $0x8,%esp
801052d2:	50                   	push   %eax
801052d3:	6a 00                	push   $0x0
801052d5:	e8 76 f5 ff ff       	call   80104850 <argstr>
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	85 c0                	test   %eax,%eax
801052df:	78 7f                	js     80105360 <sys_chdir+0xa0>
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	ff 75 f4             	pushl  -0xc(%ebp)
801052e7:	e8 94 cb ff ff       	call   80101e80 <namei>
801052ec:	83 c4 10             	add    $0x10,%esp
801052ef:	85 c0                	test   %eax,%eax
801052f1:	89 c3                	mov    %eax,%ebx
801052f3:	74 6b                	je     80105360 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052f5:	83 ec 0c             	sub    $0xc,%esp
801052f8:	50                   	push   %eax
801052f9:	e8 52 c3 ff ff       	call   80101650 <ilock>
  if(ip->type != T_DIR){
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	75 38                	jne    80105340 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	53                   	push   %ebx
8010530c:	e8 1f c4 ff ff       	call   80101730 <iunlock>
  iput(proc->cwd);
80105311:	58                   	pop    %eax
80105312:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105318:	ff 70 68             	pushl  0x68(%eax)
8010531b:	e8 60 c4 ff ff       	call   80101780 <iput>
  end_op();
80105320:	e8 fb d8 ff ff       	call   80102c20 <end_op>
  proc->cwd = ip;
80105325:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010532b:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
8010532e:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105331:	31 c0                	xor    %eax,%eax
}
80105333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105336:	c9                   	leave  
80105337:	c3                   	ret    
80105338:	90                   	nop
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	53                   	push   %ebx
80105344:	e8 77 c5 ff ff       	call   801018c0 <iunlockput>
    end_op();
80105349:	e8 d2 d8 ff ff       	call   80102c20 <end_op>
    return -1;
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105356:	eb db                	jmp    80105333 <sys_chdir+0x73>
80105358:	90                   	nop
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105360:	e8 bb d8 ff ff       	call   80102c20 <end_op>
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536a:	eb c7                	jmp    80105333 <sys_chdir+0x73>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105376:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010537c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105382:	50                   	push   %eax
80105383:	6a 00                	push   $0x0
80105385:	e8 c6 f4 ff ff       	call   80104850 <argstr>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	78 7f                	js     80105410 <sys_exec+0xa0>
80105391:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	50                   	push   %eax
8010539b:	6a 01                	push   $0x1
8010539d:	e8 1e f4 ff ff       	call   801047c0 <argint>
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	85 c0                	test   %eax,%eax
801053a7:	78 67                	js     80105410 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053a9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053af:	83 ec 04             	sub    $0x4,%esp
801053b2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053b8:	68 80 00 00 00       	push   $0x80
801053bd:	6a 00                	push   $0x0
801053bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053c5:	50                   	push   %eax
801053c6:	31 db                	xor    %ebx,%ebx
801053c8:	e8 03 f1 ff ff       	call   801044d0 <memset>
801053cd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053d6:	83 ec 08             	sub    $0x8,%esp
801053d9:	57                   	push   %edi
801053da:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053dd:	50                   	push   %eax
801053de:	e8 5d f3 ff ff       	call   80104740 <fetchint>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 26                	js     80105410 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053ea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053f0:	85 c0                	test   %eax,%eax
801053f2:	74 2c                	je     80105420 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	56                   	push   %esi
801053f8:	50                   	push   %eax
801053f9:	e8 72 f3 ff ff       	call   80104770 <fetchstr>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 0b                	js     80105410 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105405:	83 c3 01             	add    $0x1,%ebx
80105408:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010540b:	83 fb 20             	cmp    $0x20,%ebx
8010540e:	75 c0                	jne    801053d0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105418:	5b                   	pop    %ebx
80105419:	5e                   	pop    %esi
8010541a:	5f                   	pop    %edi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105420:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105426:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105429:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105430:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105434:	50                   	push   %eax
80105435:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010543b:	e8 b0 b5 ff ff       	call   801009f0 <exec>
80105440:	83 c4 10             	add    $0x10,%esp
}
80105443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105446:	5b                   	pop    %ebx
80105447:	5e                   	pop    %esi
80105448:	5f                   	pop    %edi
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    
8010544b:	90                   	nop
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_pipe>:

int
sys_pipe(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105456:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105459:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010545c:	6a 08                	push   $0x8
8010545e:	50                   	push   %eax
8010545f:	6a 00                	push   $0x0
80105461:	e8 9a f3 ff ff       	call   80104800 <argptr>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 48                	js     801054b5 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010546d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105470:	83 ec 08             	sub    $0x8,%esp
80105473:	50                   	push   %eax
80105474:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105477:	50                   	push   %eax
80105478:	e8 d3 de ff ff       	call   80103350 <pipealloc>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	78 31                	js     801054b5 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105484:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105487:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010548e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105490:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105494:	85 d2                	test   %edx,%edx
80105496:	74 28                	je     801054c0 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c0 01             	add    $0x1,%eax
8010549b:	83 f8 10             	cmp    $0x10,%eax
8010549e:	75 f0                	jne    80105490 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	53                   	push   %ebx
801054a4:	e8 67 b9 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801054a9:	58                   	pop    %eax
801054aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801054ad:	e8 5e b9 ff ff       	call   80100e10 <fileclose>
    return -1;
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ba:	eb 45                	jmp    80105501 <sys_pipe+0xb1>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054c0:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054c6:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054c8:	89 5e 28             	mov    %ebx,0x28(%esi)
801054cb:	90                   	nop
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801054d0:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
801054d5:	74 19                	je     801054f0 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054d7:	83 c2 01             	add    $0x1,%edx
801054da:	83 fa 10             	cmp    $0x10,%edx
801054dd:	75 f1                	jne    801054d0 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801054df:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
801054e6:	eb b8                	jmp    801054a0 <sys_pipe+0x50>
801054e8:	90                   	nop
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054f0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801054f7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801054f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801054ff:	31 c0                	xor    %eax,%eax
}
80105501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	66 90                	xchg   %ax,%ax
8010550b:	66 90                	xchg   %ax,%ax
8010550d:	66 90                	xchg   %ax,%ax
8010550f:	90                   	nop

80105510 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105513:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105514:	e9 c7 e4 ff ff       	jmp    801039e0 <fork>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exit>:
}

int
sys_exit(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 08             	sub    $0x8,%esp
  exit();
80105526:	e8 35 e7 ff ff       	call   80103c60 <exit>
  return 0;  // not reached
}
8010552b:	31 c0                	xor    %eax,%eax
8010552d:	c9                   	leave  
8010552e:	c3                   	ret    
8010552f:	90                   	nop

80105530 <sys_wait>:

int
sys_wait(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105533:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105534:	e9 77 e9 ff ff       	jmp    80103eb0 <wait>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_kill>:
}

int
sys_kill(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105546:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105549:	50                   	push   %eax
8010554a:	6a 00                	push   $0x0
8010554c:	e8 6f f2 ff ff       	call   801047c0 <argint>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	78 18                	js     80105570 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	ff 75 f4             	pushl  -0xc(%ebp)
8010555e:	e8 9d ea ff ff       	call   80104000 <kill>
80105563:	83 c4 10             	add    $0x10,%esp
}
80105566:	c9                   	leave  
80105567:	c3                   	ret    
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105575:	c9                   	leave  
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105586:	55                   	push   %ebp
80105587:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105589:	8b 40 10             	mov    0x10(%eax),%eax
}
8010558c:	5d                   	pop    %ebp
8010558d:	c3                   	ret    
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_sbrk>:

int
sys_sbrk(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
80105597:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010559a:	50                   	push   %eax
8010559b:	6a 00                	push   $0x0
8010559d:	e8 1e f2 ff ff       	call   801047c0 <argint>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	78 27                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801055a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801055af:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801055b2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055b4:	ff 75 f4             	pushl  -0xc(%ebp)
801055b7:	e8 b4 e3 ff ff       	call   80103970 <growproc>
801055bc:	83 c4 10             	add    $0x10,%esp
801055bf:	85 c0                	test   %eax,%eax
801055c1:	78 0d                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055c3:	89 d8                	mov    %ebx,%eax
}
801055c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c8:	c9                   	leave  
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	eb ee                	jmp    801055c5 <sys_sbrk+0x35>
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055e7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 ce f1 ff ff       	call   801047c0 <argint>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	0f 88 8a 00 00 00    	js     80105687 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	68 e0 6d 11 80       	push   $0x80116de0
80105605:	e8 96 ec ff ff       	call   801042a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010560a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010560d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105610:	8b 1d 20 76 11 80    	mov    0x80117620,%ebx
  while(ticks - ticks0 < n){
80105616:	85 d2                	test   %edx,%edx
80105618:	75 27                	jne    80105641 <sys_sleep+0x61>
8010561a:	eb 54                	jmp    80105670 <sys_sleep+0x90>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	68 e0 6d 11 80       	push   $0x80116de0
80105628:	68 20 76 11 80       	push   $0x80117620
8010562d:	e8 be e7 ff ff       	call   80103df0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105632:	a1 20 76 11 80       	mov    0x80117620,%eax
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	29 d8                	sub    %ebx,%eax
8010563c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010563f:	73 2f                	jae    80105670 <sys_sleep+0x90>
    if(proc->killed){
80105641:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105647:	8b 40 24             	mov    0x24(%eax),%eax
8010564a:	85 c0                	test   %eax,%eax
8010564c:	74 d2                	je     80105620 <sys_sleep+0x40>
      release(&tickslock);
8010564e:	83 ec 0c             	sub    $0xc,%esp
80105651:	68 e0 6d 11 80       	push   $0x80116de0
80105656:	e8 25 ee ff ff       	call   80104480 <release>
      return -1;
8010565b:	83 c4 10             	add    $0x10,%esp
8010565e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105666:	c9                   	leave  
80105667:	c3                   	ret    
80105668:	90                   	nop
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	68 e0 6d 11 80       	push   $0x80116de0
80105678:	e8 03 ee ff ff       	call   80104480 <release>
  return 0;
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	31 c0                	xor    %eax,%eax
}
80105682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105685:	c9                   	leave  
80105686:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb d5                	jmp    80105663 <sys_sleep+0x83>
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	53                   	push   %ebx
80105694:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105697:	68 e0 6d 11 80       	push   $0x80116de0
8010569c:	e8 ff eb ff ff       	call   801042a0 <acquire>
  xticks = ticks;
801056a1:	8b 1d 20 76 11 80    	mov    0x80117620,%ebx
  release(&tickslock);
801056a7:	c7 04 24 e0 6d 11 80 	movl   $0x80116de0,(%esp)
801056ae:	e8 cd ed ff ff       	call   80104480 <release>
  return xticks;
}
801056b3:	89 d8                	mov    %ebx,%eax
801056b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056c0 <sys_signal>:

int
sys_signal(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 20             	sub    $0x20,%esp
  int signum;
  sighandler_t handler;
  if(argint(0,&signum)< 0||  argptr(1,(char**)&handler,sizeof(sighandler_t))<0){
801056c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 00                	push   $0x0
801056cc:	e8 ef f0 ff ff       	call   801047c0 <argint>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 30                	js     80105708 <sys_signal+0x48>
801056d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056db:	83 ec 04             	sub    $0x4,%esp
801056de:	6a 04                	push   $0x4
801056e0:	50                   	push   %eax
801056e1:	6a 01                	push   $0x1
801056e3:	e8 18 f1 ff ff       	call   80104800 <argptr>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	78 19                	js     80105708 <sys_signal+0x48>
    return -1;
  }

  return (int)signal(signum,handler);
801056ef:	83 ec 08             	sub    $0x8,%esp
801056f2:	ff 75 f4             	pushl  -0xc(%ebp)
801056f5:	ff 75 f0             	pushl  -0x10(%ebp)
801056f8:	e8 53 ea ff ff       	call   80104150 <signal>
801056fd:	83 c4 10             	add    $0x10,%esp

80105700:	c9                   	leave  
80105701:	c3                   	ret    
80105702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_signal(void)
{
  int signum;
  sighandler_t handler;
  if(argint(0,&signum)< 0||  argptr(1,(char**)&handler,sizeof(sighandler_t))<0){
    return -1;
80105708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  return (int)signal(signum,handler);

8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop

80105710 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105710:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105711:	ba 43 00 00 00       	mov    $0x43,%edx
80105716:	b8 34 00 00 00       	mov    $0x34,%eax
8010571b:	89 e5                	mov    %esp,%ebp
8010571d:	83 ec 14             	sub    $0x14,%esp
80105720:	ee                   	out    %al,(%dx)
80105721:	ba 40 00 00 00       	mov    $0x40,%edx
80105726:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
8010572b:	ee                   	out    %al,(%dx)
8010572c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105731:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105732:	6a 00                	push   $0x0
80105734:	e8 47 db ff ff       	call   80103280 <picenable>
}
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	c9                   	leave  
8010573d:	c3                   	ret    

8010573e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010573e:	1e                   	push   %ds
  pushl %es
8010573f:	06                   	push   %es
  pushl %fs
80105740:	0f a0                	push   %fs
  pushl %gs
80105742:	0f a8                	push   %gs
  pushal
80105744:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105745:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105749:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010574b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010574d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105751:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105753:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105755:	54                   	push   %esp
  call trap
80105756:	e8 e5 00 00 00       	call   80105840 <trap>
  addl $4, %esp
8010575b:	83 c4 04             	add    $0x4,%esp

8010575e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010575e:	61                   	popa   
  popl %gs
8010575f:	0f a9                	pop    %gs
  popl %fs
80105761:	0f a1                	pop    %fs
  popl %es
80105763:	07                   	pop    %es
  popl %ds
80105764:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105765:	83 c4 08             	add    $0x8,%esp
  iret
80105768:	cf                   	iret   
80105769:	66 90                	xchg   %ax,%ax
8010576b:	66 90                	xchg   %ax,%ax
8010576d:	66 90                	xchg   %ax,%ax
8010576f:	90                   	nop

80105770 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105770:	31 c0                	xor    %eax,%eax
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105778:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010577f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105784:	c6 04 c5 24 6e 11 80 	movb   $0x0,-0x7fee91dc(,%eax,8)
8010578b:	00 
8010578c:	66 89 0c c5 22 6e 11 	mov    %cx,-0x7fee91de(,%eax,8)
80105793:	80 
80105794:	c6 04 c5 25 6e 11 80 	movb   $0x8e,-0x7fee91db(,%eax,8)
8010579b:	8e 
8010579c:	66 89 14 c5 20 6e 11 	mov    %dx,-0x7fee91e0(,%eax,8)
801057a3:	80 
801057a4:	c1 ea 10             	shr    $0x10,%edx
801057a7:	66 89 14 c5 26 6e 11 	mov    %dx,-0x7fee91da(,%eax,8)
801057ae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801057af:	83 c0 01             	add    $0x1,%eax
801057b2:	3d 00 01 00 00       	cmp    $0x100,%eax
801057b7:	75 bf                	jne    80105778 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057b9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057ba:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057bf:	89 e5                	mov    %esp,%ebp
801057c1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057c4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801057c9:	68 59 77 10 80       	push   $0x80107759
801057ce:	68 e0 6d 11 80       	push   $0x80116de0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057d3:	66 89 15 22 70 11 80 	mov    %dx,0x80117022
801057da:	c6 05 24 70 11 80 00 	movb   $0x0,0x80117024
801057e1:	66 a3 20 70 11 80    	mov    %ax,0x80117020
801057e7:	c1 e8 10             	shr    $0x10,%eax
801057ea:	c6 05 25 70 11 80 ef 	movb   $0xef,0x80117025
801057f1:	66 a3 26 70 11 80    	mov    %ax,0x80117026

  initlock(&tickslock, "time");
801057f7:	e8 84 ea ff ff       	call   80104280 <initlock>
}
801057fc:	83 c4 10             	add    $0x10,%esp
801057ff:	c9                   	leave  
80105800:	c3                   	ret    
80105801:	eb 0d                	jmp    80105810 <idtinit>
80105803:	90                   	nop
80105804:	90                   	nop
80105805:	90                   	nop
80105806:	90                   	nop
80105807:	90                   	nop
80105808:	90                   	nop
80105809:	90                   	nop
8010580a:	90                   	nop
8010580b:	90                   	nop
8010580c:	90                   	nop
8010580d:	90                   	nop
8010580e:	90                   	nop
8010580f:	90                   	nop

80105810 <idtinit>:

void
idtinit(void)
{
80105810:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105811:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105816:	89 e5                	mov    %esp,%ebp
80105818:	83 ec 10             	sub    $0x10,%esp
8010581b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010581f:	b8 20 6e 11 80       	mov    $0x80116e20,%eax
80105824:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105828:	c1 e8 10             	shr    $0x10,%eax
8010582b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010582f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105832:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
80105846:	83 ec 0c             	sub    $0xc,%esp
80105849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010584c:	8b 43 30             	mov    0x30(%ebx),%eax
8010584f:	83 f8 40             	cmp    $0x40,%eax
80105852:	0f 84 f8 00 00 00    	je     80105950 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105858:	83 e8 20             	sub    $0x20,%eax
8010585b:	83 f8 1f             	cmp    $0x1f,%eax
8010585e:	77 68                	ja     801058c8 <trap+0x88>
80105860:	ff 24 85 00 78 10 80 	jmp    *-0x7fef8800(,%eax,4)
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105870:	e8 5b ce ff ff       	call   801026d0 <cpunum>
80105875:	85 c0                	test   %eax,%eax
80105877:	0f 84 b3 01 00 00    	je     80105a30 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010587d:	e8 ee ce ff ff       	call   80102770 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105882:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105888:	85 c0                	test   %eax,%eax
8010588a:	74 2d                	je     801058b9 <trap+0x79>
8010588c:	8b 50 24             	mov    0x24(%eax),%edx
8010588f:	85 d2                	test   %edx,%edx
80105891:	0f 85 86 00 00 00    	jne    8010591d <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105897:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010589b:	0f 84 ef 00 00 00    	je     80105990 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058a1:	8b 40 24             	mov    0x24(%eax),%eax
801058a4:	85 c0                	test   %eax,%eax
801058a6:	74 11                	je     801058b9 <trap+0x79>
801058a8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801058ac:	83 e0 03             	and    $0x3,%eax
801058af:	66 83 f8 03          	cmp    $0x3,%ax
801058b3:	0f 84 c1 00 00 00    	je     8010597a <trap+0x13a>
    exit();
}
801058b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058bc:	5b                   	pop    %ebx
801058bd:	5e                   	pop    %esi
801058be:	5f                   	pop    %edi
801058bf:	5d                   	pop    %ebp
801058c0:	c3                   	ret    
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801058c8:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801058cf:	85 c9                	test   %ecx,%ecx
801058d1:	0f 84 8d 01 00 00    	je     80105a64 <trap+0x224>
801058d7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801058db:	0f 84 83 01 00 00    	je     80105a64 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058e1:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058e4:	8b 73 38             	mov    0x38(%ebx),%esi
801058e7:	e8 e4 cd ff ff       	call   801026d0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801058ec:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	50                   	push   %eax
801058f6:	ff 73 34             	pushl  0x34(%ebx)
801058f9:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801058fc:	8d 42 6c             	lea    0x6c(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058ff:	50                   	push   %eax
80105900:	ff 72 10             	pushl  0x10(%edx)
80105903:	68 bc 77 10 80       	push   $0x801077bc
80105908:	e8 53 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010590d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105913:	83 c4 20             	add    $0x20,%esp
80105916:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010591d:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105921:	83 e2 03             	and    $0x3,%edx
80105924:	66 83 fa 03          	cmp    $0x3,%dx
80105928:	0f 85 69 ff ff ff    	jne    80105897 <trap+0x57>
    exit();
8010592e:	e8 2d e3 ff ff       	call   80103c60 <exit>
80105933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105939:	85 c0                	test   %eax,%eax
8010593b:	0f 85 56 ff ff ff    	jne    80105897 <trap+0x57>
80105941:	e9 73 ff ff ff       	jmp    801058b9 <trap+0x79>
80105946:	8d 76 00             	lea    0x0(%esi),%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105950:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105956:	8b 70 24             	mov    0x24(%eax),%esi
80105959:	85 f6                	test   %esi,%esi
8010595b:	0f 85 bf 00 00 00    	jne    80105a20 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105961:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105964:	e8 67 ef ff ff       	call   801048d0 <syscall>
    if(proc->killed)
80105969:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010596f:	8b 58 24             	mov    0x24(%eax),%ebx
80105972:	85 db                	test   %ebx,%ebx
80105974:	0f 84 3f ff ff ff    	je     801058b9 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010597a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010597d:	5b                   	pop    %ebx
8010597e:	5e                   	pop    %esi
8010597f:	5f                   	pop    %edi
80105980:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105981:	e9 da e2 ff ff       	jmp    80103c60 <exit>
80105986:	8d 76 00             	lea    0x0(%esi),%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105990:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105994:	0f 85 07 ff ff ff    	jne    801058a1 <trap+0x61>
    yield();
8010599a:	e8 11 e4 ff ff       	call   80103db0 <yield>
8010599f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059a5:	85 c0                	test   %eax,%eax
801059a7:	0f 85 f4 fe ff ff    	jne    801058a1 <trap+0x61>
801059ad:	e9 07 ff ff ff       	jmp    801058b9 <trap+0x79>
801059b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801059b8:	e8 f3 cb ff ff       	call   801025b0 <kbdintr>
    lapiceoi();
801059bd:	e8 ae cd ff ff       	call   80102770 <lapiceoi>
    break;
801059c2:	e9 bb fe ff ff       	jmp    80105882 <trap+0x42>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801059d0:	e8 2b 02 00 00       	call   80105c00 <uartintr>
801059d5:	e9 a3 fe ff ff       	jmp    8010587d <trap+0x3d>
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801059e4:	8b 7b 38             	mov    0x38(%ebx),%edi
801059e7:	e8 e4 cc ff ff       	call   801026d0 <cpunum>
801059ec:	57                   	push   %edi
801059ed:	56                   	push   %esi
801059ee:	50                   	push   %eax
801059ef:	68 64 77 10 80       	push   $0x80107764
801059f4:	e8 67 ac ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
801059f9:	e8 72 cd ff ff       	call   80102770 <lapiceoi>
    break;
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	e9 7c fe ff ff       	jmp    80105882 <trap+0x42>
80105a06:	8d 76 00             	lea    0x0(%esi),%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a10:	e8 0b c6 ff ff       	call   80102020 <ideintr>
    lapiceoi();
80105a15:	e8 56 cd ff ff       	call   80102770 <lapiceoi>
    break;
80105a1a:	e9 63 fe ff ff       	jmp    80105882 <trap+0x42>
80105a1f:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105a20:	e8 3b e2 ff ff       	call   80103c60 <exit>
80105a25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a2b:	e9 31 ff ff ff       	jmp    80105961 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	68 e0 6d 11 80       	push   $0x80116de0
80105a38:	e8 63 e8 ff ff       	call   801042a0 <acquire>
      ticks++;
      wakeup(&ticks);
80105a3d:	c7 04 24 20 76 11 80 	movl   $0x80117620,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105a44:	83 05 20 76 11 80 01 	addl   $0x1,0x80117620
      wakeup(&ticks);
80105a4b:	e8 50 e5 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
80105a50:	c7 04 24 e0 6d 11 80 	movl   $0x80116de0,(%esp)
80105a57:	e8 24 ea ff ff       	call   80104480 <release>
80105a5c:	83 c4 10             	add    $0x10,%esp
80105a5f:	e9 19 fe ff ff       	jmp    8010587d <trap+0x3d>
80105a64:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a67:	8b 73 38             	mov    0x38(%ebx),%esi
80105a6a:	e8 61 cc ff ff       	call   801026d0 <cpunum>
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	57                   	push   %edi
80105a73:	56                   	push   %esi
80105a74:	50                   	push   %eax
80105a75:	ff 73 30             	pushl  0x30(%ebx)
80105a78:	68 88 77 10 80       	push   $0x80107788
80105a7d:	e8 de ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105a82:	83 c4 14             	add    $0x14,%esp
80105a85:	68 5e 77 10 80       	push   $0x8010775e
80105a8a:	e8 e1 a8 ff ff       	call   80100370 <panic>
80105a8f:	90                   	nop

80105a90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a90:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a95:	55                   	push   %ebp
80105a96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	74 1c                	je     80105ab8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aa1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105aa2:	a8 01                	test   $0x1,%al
80105aa4:	74 12                	je     80105ab8 <uartgetc+0x28>
80105aa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105aac:	0f b6 c0             	movzbl %al,%eax
}
80105aaf:	5d                   	pop    %ebp
80105ab0:	c3                   	ret    
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105abd:	5d                   	pop    %ebp
80105abe:	c3                   	ret    
80105abf:	90                   	nop

80105ac0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	53                   	push   %ebx
80105ac6:	89 c7                	mov    %eax,%edi
80105ac8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105acd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ad2:	83 ec 0c             	sub    $0xc,%esp
80105ad5:	eb 1b                	jmp    80105af2 <uartputc.part.0+0x32>
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	6a 0a                	push   $0xa
80105ae5:	e8 a6 cc ff ff       	call   80102790 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	83 eb 01             	sub    $0x1,%ebx
80105af0:	74 07                	je     80105af9 <uartputc.part.0+0x39>
80105af2:	89 f2                	mov    %esi,%edx
80105af4:	ec                   	in     (%dx),%al
80105af5:	a8 20                	test   $0x20,%al
80105af7:	74 e7                	je     80105ae0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105af9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105afe:	89 f8                	mov    %edi,%eax
80105b00:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret    
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105b10:	55                   	push   %ebp
80105b11:	31 c9                	xor    %ecx,%ecx
80105b13:	89 c8                	mov    %ecx,%eax
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	57                   	push   %edi
80105b18:	56                   	push   %esi
80105b19:	53                   	push   %ebx
80105b1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b1f:	89 da                	mov    %ebx,%edx
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	ee                   	out    %al,(%dx)
80105b25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b2f:	89 fa                	mov    %edi,%edx
80105b31:	ee                   	out    %al,(%dx)
80105b32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b3c:	ee                   	out    %al,(%dx)
80105b3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b42:	89 c8                	mov    %ecx,%eax
80105b44:	89 f2                	mov    %esi,%edx
80105b46:	ee                   	out    %al,(%dx)
80105b47:	b8 03 00 00 00       	mov    $0x3,%eax
80105b4c:	89 fa                	mov    %edi,%edx
80105b4e:	ee                   	out    %al,(%dx)
80105b4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b54:	89 c8                	mov    %ecx,%eax
80105b56:	ee                   	out    %al,(%dx)
80105b57:	b8 01 00 00 00       	mov    $0x1,%eax
80105b5c:	89 f2                	mov    %esi,%edx
80105b5e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b64:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b65:	3c ff                	cmp    $0xff,%al
80105b67:	74 5a                	je     80105bc3 <uartinit+0xb3>
    return;
  uart = 1;
80105b69:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105b70:	00 00 00 
80105b73:	89 da                	mov    %ebx,%edx
80105b75:	ec                   	in     (%dx),%al
80105b76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b7b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105b7c:	83 ec 0c             	sub    $0xc,%esp
80105b7f:	6a 04                	push   $0x4
80105b81:	e8 fa d6 ff ff       	call   80103280 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105b86:	59                   	pop    %ecx
80105b87:	5b                   	pop    %ebx
80105b88:	6a 00                	push   $0x0
80105b8a:	6a 04                	push   $0x4
80105b8c:	bb 80 78 10 80       	mov    $0x80107880,%ebx
80105b91:	e8 ea c6 ff ff       	call   80102280 <ioapicenable>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	b8 78 00 00 00       	mov    $0x78,%eax
80105b9e:	eb 0a                	jmp    80105baa <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ba0:	83 c3 01             	add    $0x1,%ebx
80105ba3:	0f be 03             	movsbl (%ebx),%eax
80105ba6:	84 c0                	test   %al,%al
80105ba8:	74 19                	je     80105bc3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105baa:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105bb0:	85 d2                	test   %edx,%edx
80105bb2:	74 ec                	je     80105ba0 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105bb4:	83 c3 01             	add    $0x1,%ebx
80105bb7:	e8 04 ff ff ff       	call   80105ac0 <uartputc.part.0>
80105bbc:	0f be 03             	movsbl (%ebx),%eax
80105bbf:	84 c0                	test   %al,%al
80105bc1:	75 e7                	jne    80105baa <uartinit+0x9a>
    uartputc(*p);
}
80105bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc6:	5b                   	pop    %ebx
80105bc7:	5e                   	pop    %esi
80105bc8:	5f                   	pop    %edi
80105bc9:	5d                   	pop    %ebp
80105bca:	c3                   	ret    
80105bcb:	90                   	nop
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bd0:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bd6:	55                   	push   %ebp
80105bd7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105bd9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105bde:	74 10                	je     80105bf0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105be0:	5d                   	pop    %ebp
80105be1:	e9 da fe ff ff       	jmp    80105ac0 <uartputc.part.0>
80105be6:	8d 76 00             	lea    0x0(%esi),%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105bf0:	5d                   	pop    %ebp
80105bf1:	c3                   	ret    
80105bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c06:	68 90 5a 10 80       	push   $0x80105a90
80105c0b:	e8 e0 ab ff ff       	call   801007f0 <consoleintr>
}
80105c10:	83 c4 10             	add    $0x10,%esp
80105c13:	c9                   	leave  
80105c14:	c3                   	ret    

80105c15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c15:	6a 00                	push   $0x0
  pushl $0
80105c17:	6a 00                	push   $0x0
  jmp alltraps
80105c19:	e9 20 fb ff ff       	jmp    8010573e <alltraps>

80105c1e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $1
80105c20:	6a 01                	push   $0x1
  jmp alltraps
80105c22:	e9 17 fb ff ff       	jmp    8010573e <alltraps>

80105c27 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $2
80105c29:	6a 02                	push   $0x2
  jmp alltraps
80105c2b:	e9 0e fb ff ff       	jmp    8010573e <alltraps>

80105c30 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c30:	6a 00                	push   $0x0
  pushl $3
80105c32:	6a 03                	push   $0x3
  jmp alltraps
80105c34:	e9 05 fb ff ff       	jmp    8010573e <alltraps>

80105c39 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $4
80105c3b:	6a 04                	push   $0x4
  jmp alltraps
80105c3d:	e9 fc fa ff ff       	jmp    8010573e <alltraps>

80105c42 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $5
80105c44:	6a 05                	push   $0x5
  jmp alltraps
80105c46:	e9 f3 fa ff ff       	jmp    8010573e <alltraps>

80105c4b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $6
80105c4d:	6a 06                	push   $0x6
  jmp alltraps
80105c4f:	e9 ea fa ff ff       	jmp    8010573e <alltraps>

80105c54 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $7
80105c56:	6a 07                	push   $0x7
  jmp alltraps
80105c58:	e9 e1 fa ff ff       	jmp    8010573e <alltraps>

80105c5d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c5d:	6a 08                	push   $0x8
  jmp alltraps
80105c5f:	e9 da fa ff ff       	jmp    8010573e <alltraps>

80105c64 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $9
80105c66:	6a 09                	push   $0x9
  jmp alltraps
80105c68:	e9 d1 fa ff ff       	jmp    8010573e <alltraps>

80105c6d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c6d:	6a 0a                	push   $0xa
  jmp alltraps
80105c6f:	e9 ca fa ff ff       	jmp    8010573e <alltraps>

80105c74 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c74:	6a 0b                	push   $0xb
  jmp alltraps
80105c76:	e9 c3 fa ff ff       	jmp    8010573e <alltraps>

80105c7b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c7b:	6a 0c                	push   $0xc
  jmp alltraps
80105c7d:	e9 bc fa ff ff       	jmp    8010573e <alltraps>

80105c82 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c82:	6a 0d                	push   $0xd
  jmp alltraps
80105c84:	e9 b5 fa ff ff       	jmp    8010573e <alltraps>

80105c89 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c89:	6a 0e                	push   $0xe
  jmp alltraps
80105c8b:	e9 ae fa ff ff       	jmp    8010573e <alltraps>

80105c90 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $15
80105c92:	6a 0f                	push   $0xf
  jmp alltraps
80105c94:	e9 a5 fa ff ff       	jmp    8010573e <alltraps>

80105c99 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $16
80105c9b:	6a 10                	push   $0x10
  jmp alltraps
80105c9d:	e9 9c fa ff ff       	jmp    8010573e <alltraps>

80105ca2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ca2:	6a 11                	push   $0x11
  jmp alltraps
80105ca4:	e9 95 fa ff ff       	jmp    8010573e <alltraps>

80105ca9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $18
80105cab:	6a 12                	push   $0x12
  jmp alltraps
80105cad:	e9 8c fa ff ff       	jmp    8010573e <alltraps>

80105cb2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $19
80105cb4:	6a 13                	push   $0x13
  jmp alltraps
80105cb6:	e9 83 fa ff ff       	jmp    8010573e <alltraps>

80105cbb <vector20>:
.globl vector20
vector20:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $20
80105cbd:	6a 14                	push   $0x14
  jmp alltraps
80105cbf:	e9 7a fa ff ff       	jmp    8010573e <alltraps>

80105cc4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $21
80105cc6:	6a 15                	push   $0x15
  jmp alltraps
80105cc8:	e9 71 fa ff ff       	jmp    8010573e <alltraps>

80105ccd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $22
80105ccf:	6a 16                	push   $0x16
  jmp alltraps
80105cd1:	e9 68 fa ff ff       	jmp    8010573e <alltraps>

80105cd6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $23
80105cd8:	6a 17                	push   $0x17
  jmp alltraps
80105cda:	e9 5f fa ff ff       	jmp    8010573e <alltraps>

80105cdf <vector24>:
.globl vector24
vector24:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $24
80105ce1:	6a 18                	push   $0x18
  jmp alltraps
80105ce3:	e9 56 fa ff ff       	jmp    8010573e <alltraps>

80105ce8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $25
80105cea:	6a 19                	push   $0x19
  jmp alltraps
80105cec:	e9 4d fa ff ff       	jmp    8010573e <alltraps>

80105cf1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $26
80105cf3:	6a 1a                	push   $0x1a
  jmp alltraps
80105cf5:	e9 44 fa ff ff       	jmp    8010573e <alltraps>

80105cfa <vector27>:
.globl vector27
vector27:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $27
80105cfc:	6a 1b                	push   $0x1b
  jmp alltraps
80105cfe:	e9 3b fa ff ff       	jmp    8010573e <alltraps>

80105d03 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $28
80105d05:	6a 1c                	push   $0x1c
  jmp alltraps
80105d07:	e9 32 fa ff ff       	jmp    8010573e <alltraps>

80105d0c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $29
80105d0e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d10:	e9 29 fa ff ff       	jmp    8010573e <alltraps>

80105d15 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $30
80105d17:	6a 1e                	push   $0x1e
  jmp alltraps
80105d19:	e9 20 fa ff ff       	jmp    8010573e <alltraps>

80105d1e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $31
80105d20:	6a 1f                	push   $0x1f
  jmp alltraps
80105d22:	e9 17 fa ff ff       	jmp    8010573e <alltraps>

80105d27 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $32
80105d29:	6a 20                	push   $0x20
  jmp alltraps
80105d2b:	e9 0e fa ff ff       	jmp    8010573e <alltraps>

80105d30 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $33
80105d32:	6a 21                	push   $0x21
  jmp alltraps
80105d34:	e9 05 fa ff ff       	jmp    8010573e <alltraps>

80105d39 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $34
80105d3b:	6a 22                	push   $0x22
  jmp alltraps
80105d3d:	e9 fc f9 ff ff       	jmp    8010573e <alltraps>

80105d42 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $35
80105d44:	6a 23                	push   $0x23
  jmp alltraps
80105d46:	e9 f3 f9 ff ff       	jmp    8010573e <alltraps>

80105d4b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $36
80105d4d:	6a 24                	push   $0x24
  jmp alltraps
80105d4f:	e9 ea f9 ff ff       	jmp    8010573e <alltraps>

80105d54 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $37
80105d56:	6a 25                	push   $0x25
  jmp alltraps
80105d58:	e9 e1 f9 ff ff       	jmp    8010573e <alltraps>

80105d5d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $38
80105d5f:	6a 26                	push   $0x26
  jmp alltraps
80105d61:	e9 d8 f9 ff ff       	jmp    8010573e <alltraps>

80105d66 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $39
80105d68:	6a 27                	push   $0x27
  jmp alltraps
80105d6a:	e9 cf f9 ff ff       	jmp    8010573e <alltraps>

80105d6f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $40
80105d71:	6a 28                	push   $0x28
  jmp alltraps
80105d73:	e9 c6 f9 ff ff       	jmp    8010573e <alltraps>

80105d78 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d78:	6a 00                	push   $0x0
  pushl $41
80105d7a:	6a 29                	push   $0x29
  jmp alltraps
80105d7c:	e9 bd f9 ff ff       	jmp    8010573e <alltraps>

80105d81 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d81:	6a 00                	push   $0x0
  pushl $42
80105d83:	6a 2a                	push   $0x2a
  jmp alltraps
80105d85:	e9 b4 f9 ff ff       	jmp    8010573e <alltraps>

80105d8a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $43
80105d8c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d8e:	e9 ab f9 ff ff       	jmp    8010573e <alltraps>

80105d93 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $44
80105d95:	6a 2c                	push   $0x2c
  jmp alltraps
80105d97:	e9 a2 f9 ff ff       	jmp    8010573e <alltraps>

80105d9c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d9c:	6a 00                	push   $0x0
  pushl $45
80105d9e:	6a 2d                	push   $0x2d
  jmp alltraps
80105da0:	e9 99 f9 ff ff       	jmp    8010573e <alltraps>

80105da5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $46
80105da7:	6a 2e                	push   $0x2e
  jmp alltraps
80105da9:	e9 90 f9 ff ff       	jmp    8010573e <alltraps>

80105dae <vector47>:
.globl vector47
vector47:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $47
80105db0:	6a 2f                	push   $0x2f
  jmp alltraps
80105db2:	e9 87 f9 ff ff       	jmp    8010573e <alltraps>

80105db7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $48
80105db9:	6a 30                	push   $0x30
  jmp alltraps
80105dbb:	e9 7e f9 ff ff       	jmp    8010573e <alltraps>

80105dc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $49
80105dc2:	6a 31                	push   $0x31
  jmp alltraps
80105dc4:	e9 75 f9 ff ff       	jmp    8010573e <alltraps>

80105dc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $50
80105dcb:	6a 32                	push   $0x32
  jmp alltraps
80105dcd:	e9 6c f9 ff ff       	jmp    8010573e <alltraps>

80105dd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $51
80105dd4:	6a 33                	push   $0x33
  jmp alltraps
80105dd6:	e9 63 f9 ff ff       	jmp    8010573e <alltraps>

80105ddb <vector52>:
.globl vector52
vector52:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $52
80105ddd:	6a 34                	push   $0x34
  jmp alltraps
80105ddf:	e9 5a f9 ff ff       	jmp    8010573e <alltraps>

80105de4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $53
80105de6:	6a 35                	push   $0x35
  jmp alltraps
80105de8:	e9 51 f9 ff ff       	jmp    8010573e <alltraps>

80105ded <vector54>:
.globl vector54
vector54:
  pushl $0
80105ded:	6a 00                	push   $0x0
  pushl $54
80105def:	6a 36                	push   $0x36
  jmp alltraps
80105df1:	e9 48 f9 ff ff       	jmp    8010573e <alltraps>

80105df6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $55
80105df8:	6a 37                	push   $0x37
  jmp alltraps
80105dfa:	e9 3f f9 ff ff       	jmp    8010573e <alltraps>

80105dff <vector56>:
.globl vector56
vector56:
  pushl $0
80105dff:	6a 00                	push   $0x0
  pushl $56
80105e01:	6a 38                	push   $0x38
  jmp alltraps
80105e03:	e9 36 f9 ff ff       	jmp    8010573e <alltraps>

80105e08 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e08:	6a 00                	push   $0x0
  pushl $57
80105e0a:	6a 39                	push   $0x39
  jmp alltraps
80105e0c:	e9 2d f9 ff ff       	jmp    8010573e <alltraps>

80105e11 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e11:	6a 00                	push   $0x0
  pushl $58
80105e13:	6a 3a                	push   $0x3a
  jmp alltraps
80105e15:	e9 24 f9 ff ff       	jmp    8010573e <alltraps>

80105e1a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $59
80105e1c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e1e:	e9 1b f9 ff ff       	jmp    8010573e <alltraps>

80105e23 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e23:	6a 00                	push   $0x0
  pushl $60
80105e25:	6a 3c                	push   $0x3c
  jmp alltraps
80105e27:	e9 12 f9 ff ff       	jmp    8010573e <alltraps>

80105e2c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e2c:	6a 00                	push   $0x0
  pushl $61
80105e2e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e30:	e9 09 f9 ff ff       	jmp    8010573e <alltraps>

80105e35 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e35:	6a 00                	push   $0x0
  pushl $62
80105e37:	6a 3e                	push   $0x3e
  jmp alltraps
80105e39:	e9 00 f9 ff ff       	jmp    8010573e <alltraps>

80105e3e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $63
80105e40:	6a 3f                	push   $0x3f
  jmp alltraps
80105e42:	e9 f7 f8 ff ff       	jmp    8010573e <alltraps>

80105e47 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e47:	6a 00                	push   $0x0
  pushl $64
80105e49:	6a 40                	push   $0x40
  jmp alltraps
80105e4b:	e9 ee f8 ff ff       	jmp    8010573e <alltraps>

80105e50 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e50:	6a 00                	push   $0x0
  pushl $65
80105e52:	6a 41                	push   $0x41
  jmp alltraps
80105e54:	e9 e5 f8 ff ff       	jmp    8010573e <alltraps>

80105e59 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e59:	6a 00                	push   $0x0
  pushl $66
80105e5b:	6a 42                	push   $0x42
  jmp alltraps
80105e5d:	e9 dc f8 ff ff       	jmp    8010573e <alltraps>

80105e62 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $67
80105e64:	6a 43                	push   $0x43
  jmp alltraps
80105e66:	e9 d3 f8 ff ff       	jmp    8010573e <alltraps>

80105e6b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e6b:	6a 00                	push   $0x0
  pushl $68
80105e6d:	6a 44                	push   $0x44
  jmp alltraps
80105e6f:	e9 ca f8 ff ff       	jmp    8010573e <alltraps>

80105e74 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e74:	6a 00                	push   $0x0
  pushl $69
80105e76:	6a 45                	push   $0x45
  jmp alltraps
80105e78:	e9 c1 f8 ff ff       	jmp    8010573e <alltraps>

80105e7d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e7d:	6a 00                	push   $0x0
  pushl $70
80105e7f:	6a 46                	push   $0x46
  jmp alltraps
80105e81:	e9 b8 f8 ff ff       	jmp    8010573e <alltraps>

80105e86 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $71
80105e88:	6a 47                	push   $0x47
  jmp alltraps
80105e8a:	e9 af f8 ff ff       	jmp    8010573e <alltraps>

80105e8f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e8f:	6a 00                	push   $0x0
  pushl $72
80105e91:	6a 48                	push   $0x48
  jmp alltraps
80105e93:	e9 a6 f8 ff ff       	jmp    8010573e <alltraps>

80105e98 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e98:	6a 00                	push   $0x0
  pushl $73
80105e9a:	6a 49                	push   $0x49
  jmp alltraps
80105e9c:	e9 9d f8 ff ff       	jmp    8010573e <alltraps>

80105ea1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ea1:	6a 00                	push   $0x0
  pushl $74
80105ea3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ea5:	e9 94 f8 ff ff       	jmp    8010573e <alltraps>

80105eaa <vector75>:
.globl vector75
vector75:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $75
80105eac:	6a 4b                	push   $0x4b
  jmp alltraps
80105eae:	e9 8b f8 ff ff       	jmp    8010573e <alltraps>

80105eb3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105eb3:	6a 00                	push   $0x0
  pushl $76
80105eb5:	6a 4c                	push   $0x4c
  jmp alltraps
80105eb7:	e9 82 f8 ff ff       	jmp    8010573e <alltraps>

80105ebc <vector77>:
.globl vector77
vector77:
  pushl $0
80105ebc:	6a 00                	push   $0x0
  pushl $77
80105ebe:	6a 4d                	push   $0x4d
  jmp alltraps
80105ec0:	e9 79 f8 ff ff       	jmp    8010573e <alltraps>

80105ec5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ec5:	6a 00                	push   $0x0
  pushl $78
80105ec7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ec9:	e9 70 f8 ff ff       	jmp    8010573e <alltraps>

80105ece <vector79>:
.globl vector79
vector79:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $79
80105ed0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ed2:	e9 67 f8 ff ff       	jmp    8010573e <alltraps>

80105ed7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $80
80105ed9:	6a 50                	push   $0x50
  jmp alltraps
80105edb:	e9 5e f8 ff ff       	jmp    8010573e <alltraps>

80105ee0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ee0:	6a 00                	push   $0x0
  pushl $81
80105ee2:	6a 51                	push   $0x51
  jmp alltraps
80105ee4:	e9 55 f8 ff ff       	jmp    8010573e <alltraps>

80105ee9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ee9:	6a 00                	push   $0x0
  pushl $82
80105eeb:	6a 52                	push   $0x52
  jmp alltraps
80105eed:	e9 4c f8 ff ff       	jmp    8010573e <alltraps>

80105ef2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $83
80105ef4:	6a 53                	push   $0x53
  jmp alltraps
80105ef6:	e9 43 f8 ff ff       	jmp    8010573e <alltraps>

80105efb <vector84>:
.globl vector84
vector84:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $84
80105efd:	6a 54                	push   $0x54
  jmp alltraps
80105eff:	e9 3a f8 ff ff       	jmp    8010573e <alltraps>

80105f04 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $85
80105f06:	6a 55                	push   $0x55
  jmp alltraps
80105f08:	e9 31 f8 ff ff       	jmp    8010573e <alltraps>

80105f0d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f0d:	6a 00                	push   $0x0
  pushl $86
80105f0f:	6a 56                	push   $0x56
  jmp alltraps
80105f11:	e9 28 f8 ff ff       	jmp    8010573e <alltraps>

80105f16 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $87
80105f18:	6a 57                	push   $0x57
  jmp alltraps
80105f1a:	e9 1f f8 ff ff       	jmp    8010573e <alltraps>

80105f1f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $88
80105f21:	6a 58                	push   $0x58
  jmp alltraps
80105f23:	e9 16 f8 ff ff       	jmp    8010573e <alltraps>

80105f28 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f28:	6a 00                	push   $0x0
  pushl $89
80105f2a:	6a 59                	push   $0x59
  jmp alltraps
80105f2c:	e9 0d f8 ff ff       	jmp    8010573e <alltraps>

80105f31 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f31:	6a 00                	push   $0x0
  pushl $90
80105f33:	6a 5a                	push   $0x5a
  jmp alltraps
80105f35:	e9 04 f8 ff ff       	jmp    8010573e <alltraps>

80105f3a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $91
80105f3c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f3e:	e9 fb f7 ff ff       	jmp    8010573e <alltraps>

80105f43 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $92
80105f45:	6a 5c                	push   $0x5c
  jmp alltraps
80105f47:	e9 f2 f7 ff ff       	jmp    8010573e <alltraps>

80105f4c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f4c:	6a 00                	push   $0x0
  pushl $93
80105f4e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f50:	e9 e9 f7 ff ff       	jmp    8010573e <alltraps>

80105f55 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f55:	6a 00                	push   $0x0
  pushl $94
80105f57:	6a 5e                	push   $0x5e
  jmp alltraps
80105f59:	e9 e0 f7 ff ff       	jmp    8010573e <alltraps>

80105f5e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $95
80105f60:	6a 5f                	push   $0x5f
  jmp alltraps
80105f62:	e9 d7 f7 ff ff       	jmp    8010573e <alltraps>

80105f67 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $96
80105f69:	6a 60                	push   $0x60
  jmp alltraps
80105f6b:	e9 ce f7 ff ff       	jmp    8010573e <alltraps>

80105f70 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f70:	6a 00                	push   $0x0
  pushl $97
80105f72:	6a 61                	push   $0x61
  jmp alltraps
80105f74:	e9 c5 f7 ff ff       	jmp    8010573e <alltraps>

80105f79 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f79:	6a 00                	push   $0x0
  pushl $98
80105f7b:	6a 62                	push   $0x62
  jmp alltraps
80105f7d:	e9 bc f7 ff ff       	jmp    8010573e <alltraps>

80105f82 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $99
80105f84:	6a 63                	push   $0x63
  jmp alltraps
80105f86:	e9 b3 f7 ff ff       	jmp    8010573e <alltraps>

80105f8b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $100
80105f8d:	6a 64                	push   $0x64
  jmp alltraps
80105f8f:	e9 aa f7 ff ff       	jmp    8010573e <alltraps>

80105f94 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $101
80105f96:	6a 65                	push   $0x65
  jmp alltraps
80105f98:	e9 a1 f7 ff ff       	jmp    8010573e <alltraps>

80105f9d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f9d:	6a 00                	push   $0x0
  pushl $102
80105f9f:	6a 66                	push   $0x66
  jmp alltraps
80105fa1:	e9 98 f7 ff ff       	jmp    8010573e <alltraps>

80105fa6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $103
80105fa8:	6a 67                	push   $0x67
  jmp alltraps
80105faa:	e9 8f f7 ff ff       	jmp    8010573e <alltraps>

80105faf <vector104>:
.globl vector104
vector104:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $104
80105fb1:	6a 68                	push   $0x68
  jmp alltraps
80105fb3:	e9 86 f7 ff ff       	jmp    8010573e <alltraps>

80105fb8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fb8:	6a 00                	push   $0x0
  pushl $105
80105fba:	6a 69                	push   $0x69
  jmp alltraps
80105fbc:	e9 7d f7 ff ff       	jmp    8010573e <alltraps>

80105fc1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fc1:	6a 00                	push   $0x0
  pushl $106
80105fc3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fc5:	e9 74 f7 ff ff       	jmp    8010573e <alltraps>

80105fca <vector107>:
.globl vector107
vector107:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $107
80105fcc:	6a 6b                	push   $0x6b
  jmp alltraps
80105fce:	e9 6b f7 ff ff       	jmp    8010573e <alltraps>

80105fd3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $108
80105fd5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fd7:	e9 62 f7 ff ff       	jmp    8010573e <alltraps>

80105fdc <vector109>:
.globl vector109
vector109:
  pushl $0
80105fdc:	6a 00                	push   $0x0
  pushl $109
80105fde:	6a 6d                	push   $0x6d
  jmp alltraps
80105fe0:	e9 59 f7 ff ff       	jmp    8010573e <alltraps>

80105fe5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fe5:	6a 00                	push   $0x0
  pushl $110
80105fe7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fe9:	e9 50 f7 ff ff       	jmp    8010573e <alltraps>

80105fee <vector111>:
.globl vector111
vector111:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $111
80105ff0:	6a 6f                	push   $0x6f
  jmp alltraps
80105ff2:	e9 47 f7 ff ff       	jmp    8010573e <alltraps>

80105ff7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $112
80105ff9:	6a 70                	push   $0x70
  jmp alltraps
80105ffb:	e9 3e f7 ff ff       	jmp    8010573e <alltraps>

80106000 <vector113>:
.globl vector113
vector113:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $113
80106002:	6a 71                	push   $0x71
  jmp alltraps
80106004:	e9 35 f7 ff ff       	jmp    8010573e <alltraps>

80106009 <vector114>:
.globl vector114
vector114:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $114
8010600b:	6a 72                	push   $0x72
  jmp alltraps
8010600d:	e9 2c f7 ff ff       	jmp    8010573e <alltraps>

80106012 <vector115>:
.globl vector115
vector115:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $115
80106014:	6a 73                	push   $0x73
  jmp alltraps
80106016:	e9 23 f7 ff ff       	jmp    8010573e <alltraps>

8010601b <vector116>:
.globl vector116
vector116:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $116
8010601d:	6a 74                	push   $0x74
  jmp alltraps
8010601f:	e9 1a f7 ff ff       	jmp    8010573e <alltraps>

80106024 <vector117>:
.globl vector117
vector117:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $117
80106026:	6a 75                	push   $0x75
  jmp alltraps
80106028:	e9 11 f7 ff ff       	jmp    8010573e <alltraps>

8010602d <vector118>:
.globl vector118
vector118:
  pushl $0
8010602d:	6a 00                	push   $0x0
  pushl $118
8010602f:	6a 76                	push   $0x76
  jmp alltraps
80106031:	e9 08 f7 ff ff       	jmp    8010573e <alltraps>

80106036 <vector119>:
.globl vector119
vector119:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $119
80106038:	6a 77                	push   $0x77
  jmp alltraps
8010603a:	e9 ff f6 ff ff       	jmp    8010573e <alltraps>

8010603f <vector120>:
.globl vector120
vector120:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $120
80106041:	6a 78                	push   $0x78
  jmp alltraps
80106043:	e9 f6 f6 ff ff       	jmp    8010573e <alltraps>

80106048 <vector121>:
.globl vector121
vector121:
  pushl $0
80106048:	6a 00                	push   $0x0
  pushl $121
8010604a:	6a 79                	push   $0x79
  jmp alltraps
8010604c:	e9 ed f6 ff ff       	jmp    8010573e <alltraps>

80106051 <vector122>:
.globl vector122
vector122:
  pushl $0
80106051:	6a 00                	push   $0x0
  pushl $122
80106053:	6a 7a                	push   $0x7a
  jmp alltraps
80106055:	e9 e4 f6 ff ff       	jmp    8010573e <alltraps>

8010605a <vector123>:
.globl vector123
vector123:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $123
8010605c:	6a 7b                	push   $0x7b
  jmp alltraps
8010605e:	e9 db f6 ff ff       	jmp    8010573e <alltraps>

80106063 <vector124>:
.globl vector124
vector124:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $124
80106065:	6a 7c                	push   $0x7c
  jmp alltraps
80106067:	e9 d2 f6 ff ff       	jmp    8010573e <alltraps>

8010606c <vector125>:
.globl vector125
vector125:
  pushl $0
8010606c:	6a 00                	push   $0x0
  pushl $125
8010606e:	6a 7d                	push   $0x7d
  jmp alltraps
80106070:	e9 c9 f6 ff ff       	jmp    8010573e <alltraps>

80106075 <vector126>:
.globl vector126
vector126:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $126
80106077:	6a 7e                	push   $0x7e
  jmp alltraps
80106079:	e9 c0 f6 ff ff       	jmp    8010573e <alltraps>

8010607e <vector127>:
.globl vector127
vector127:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $127
80106080:	6a 7f                	push   $0x7f
  jmp alltraps
80106082:	e9 b7 f6 ff ff       	jmp    8010573e <alltraps>

80106087 <vector128>:
.globl vector128
vector128:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $128
80106089:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010608e:	e9 ab f6 ff ff       	jmp    8010573e <alltraps>

80106093 <vector129>:
.globl vector129
vector129:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $129
80106095:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010609a:	e9 9f f6 ff ff       	jmp    8010573e <alltraps>

8010609f <vector130>:
.globl vector130
vector130:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $130
801060a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060a6:	e9 93 f6 ff ff       	jmp    8010573e <alltraps>

801060ab <vector131>:
.globl vector131
vector131:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $131
801060ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060b2:	e9 87 f6 ff ff       	jmp    8010573e <alltraps>

801060b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $132
801060b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060be:	e9 7b f6 ff ff       	jmp    8010573e <alltraps>

801060c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $133
801060c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ca:	e9 6f f6 ff ff       	jmp    8010573e <alltraps>

801060cf <vector134>:
.globl vector134
vector134:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $134
801060d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060d6:	e9 63 f6 ff ff       	jmp    8010573e <alltraps>

801060db <vector135>:
.globl vector135
vector135:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $135
801060dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060e2:	e9 57 f6 ff ff       	jmp    8010573e <alltraps>

801060e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $136
801060e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060ee:	e9 4b f6 ff ff       	jmp    8010573e <alltraps>

801060f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $137
801060f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060fa:	e9 3f f6 ff ff       	jmp    8010573e <alltraps>

801060ff <vector138>:
.globl vector138
vector138:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $138
80106101:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106106:	e9 33 f6 ff ff       	jmp    8010573e <alltraps>

8010610b <vector139>:
.globl vector139
vector139:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $139
8010610d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106112:	e9 27 f6 ff ff       	jmp    8010573e <alltraps>

80106117 <vector140>:
.globl vector140
vector140:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $140
80106119:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010611e:	e9 1b f6 ff ff       	jmp    8010573e <alltraps>

80106123 <vector141>:
.globl vector141
vector141:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $141
80106125:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010612a:	e9 0f f6 ff ff       	jmp    8010573e <alltraps>

8010612f <vector142>:
.globl vector142
vector142:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $142
80106131:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106136:	e9 03 f6 ff ff       	jmp    8010573e <alltraps>

8010613b <vector143>:
.globl vector143
vector143:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $143
8010613d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106142:	e9 f7 f5 ff ff       	jmp    8010573e <alltraps>

80106147 <vector144>:
.globl vector144
vector144:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $144
80106149:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010614e:	e9 eb f5 ff ff       	jmp    8010573e <alltraps>

80106153 <vector145>:
.globl vector145
vector145:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $145
80106155:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010615a:	e9 df f5 ff ff       	jmp    8010573e <alltraps>

8010615f <vector146>:
.globl vector146
vector146:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $146
80106161:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106166:	e9 d3 f5 ff ff       	jmp    8010573e <alltraps>

8010616b <vector147>:
.globl vector147
vector147:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $147
8010616d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106172:	e9 c7 f5 ff ff       	jmp    8010573e <alltraps>

80106177 <vector148>:
.globl vector148
vector148:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $148
80106179:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010617e:	e9 bb f5 ff ff       	jmp    8010573e <alltraps>

80106183 <vector149>:
.globl vector149
vector149:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $149
80106185:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010618a:	e9 af f5 ff ff       	jmp    8010573e <alltraps>

8010618f <vector150>:
.globl vector150
vector150:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $150
80106191:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106196:	e9 a3 f5 ff ff       	jmp    8010573e <alltraps>

8010619b <vector151>:
.globl vector151
vector151:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $151
8010619d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061a2:	e9 97 f5 ff ff       	jmp    8010573e <alltraps>

801061a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $152
801061a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061ae:	e9 8b f5 ff ff       	jmp    8010573e <alltraps>

801061b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $153
801061b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061ba:	e9 7f f5 ff ff       	jmp    8010573e <alltraps>

801061bf <vector154>:
.globl vector154
vector154:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $154
801061c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061c6:	e9 73 f5 ff ff       	jmp    8010573e <alltraps>

801061cb <vector155>:
.globl vector155
vector155:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $155
801061cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061d2:	e9 67 f5 ff ff       	jmp    8010573e <alltraps>

801061d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $156
801061d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061de:	e9 5b f5 ff ff       	jmp    8010573e <alltraps>

801061e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $157
801061e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061ea:	e9 4f f5 ff ff       	jmp    8010573e <alltraps>

801061ef <vector158>:
.globl vector158
vector158:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $158
801061f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061f6:	e9 43 f5 ff ff       	jmp    8010573e <alltraps>

801061fb <vector159>:
.globl vector159
vector159:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $159
801061fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106202:	e9 37 f5 ff ff       	jmp    8010573e <alltraps>

80106207 <vector160>:
.globl vector160
vector160:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $160
80106209:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010620e:	e9 2b f5 ff ff       	jmp    8010573e <alltraps>

80106213 <vector161>:
.globl vector161
vector161:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $161
80106215:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010621a:	e9 1f f5 ff ff       	jmp    8010573e <alltraps>

8010621f <vector162>:
.globl vector162
vector162:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $162
80106221:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106226:	e9 13 f5 ff ff       	jmp    8010573e <alltraps>

8010622b <vector163>:
.globl vector163
vector163:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $163
8010622d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106232:	e9 07 f5 ff ff       	jmp    8010573e <alltraps>

80106237 <vector164>:
.globl vector164
vector164:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $164
80106239:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010623e:	e9 fb f4 ff ff       	jmp    8010573e <alltraps>

80106243 <vector165>:
.globl vector165
vector165:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $165
80106245:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010624a:	e9 ef f4 ff ff       	jmp    8010573e <alltraps>

8010624f <vector166>:
.globl vector166
vector166:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $166
80106251:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106256:	e9 e3 f4 ff ff       	jmp    8010573e <alltraps>

8010625b <vector167>:
.globl vector167
vector167:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $167
8010625d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106262:	e9 d7 f4 ff ff       	jmp    8010573e <alltraps>

80106267 <vector168>:
.globl vector168
vector168:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $168
80106269:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010626e:	e9 cb f4 ff ff       	jmp    8010573e <alltraps>

80106273 <vector169>:
.globl vector169
vector169:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $169
80106275:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010627a:	e9 bf f4 ff ff       	jmp    8010573e <alltraps>

8010627f <vector170>:
.globl vector170
vector170:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $170
80106281:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106286:	e9 b3 f4 ff ff       	jmp    8010573e <alltraps>

8010628b <vector171>:
.globl vector171
vector171:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $171
8010628d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106292:	e9 a7 f4 ff ff       	jmp    8010573e <alltraps>

80106297 <vector172>:
.globl vector172
vector172:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $172
80106299:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010629e:	e9 9b f4 ff ff       	jmp    8010573e <alltraps>

801062a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $173
801062a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062aa:	e9 8f f4 ff ff       	jmp    8010573e <alltraps>

801062af <vector174>:
.globl vector174
vector174:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $174
801062b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062b6:	e9 83 f4 ff ff       	jmp    8010573e <alltraps>

801062bb <vector175>:
.globl vector175
vector175:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $175
801062bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062c2:	e9 77 f4 ff ff       	jmp    8010573e <alltraps>

801062c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $176
801062c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ce:	e9 6b f4 ff ff       	jmp    8010573e <alltraps>

801062d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $177
801062d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062da:	e9 5f f4 ff ff       	jmp    8010573e <alltraps>

801062df <vector178>:
.globl vector178
vector178:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $178
801062e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062e6:	e9 53 f4 ff ff       	jmp    8010573e <alltraps>

801062eb <vector179>:
.globl vector179
vector179:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $179
801062ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062f2:	e9 47 f4 ff ff       	jmp    8010573e <alltraps>

801062f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $180
801062f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062fe:	e9 3b f4 ff ff       	jmp    8010573e <alltraps>

80106303 <vector181>:
.globl vector181
vector181:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $181
80106305:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010630a:	e9 2f f4 ff ff       	jmp    8010573e <alltraps>

8010630f <vector182>:
.globl vector182
vector182:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $182
80106311:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106316:	e9 23 f4 ff ff       	jmp    8010573e <alltraps>

8010631b <vector183>:
.globl vector183
vector183:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $183
8010631d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106322:	e9 17 f4 ff ff       	jmp    8010573e <alltraps>

80106327 <vector184>:
.globl vector184
vector184:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $184
80106329:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010632e:	e9 0b f4 ff ff       	jmp    8010573e <alltraps>

80106333 <vector185>:
.globl vector185
vector185:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $185
80106335:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010633a:	e9 ff f3 ff ff       	jmp    8010573e <alltraps>

8010633f <vector186>:
.globl vector186
vector186:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $186
80106341:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106346:	e9 f3 f3 ff ff       	jmp    8010573e <alltraps>

8010634b <vector187>:
.globl vector187
vector187:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $187
8010634d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106352:	e9 e7 f3 ff ff       	jmp    8010573e <alltraps>

80106357 <vector188>:
.globl vector188
vector188:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $188
80106359:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010635e:	e9 db f3 ff ff       	jmp    8010573e <alltraps>

80106363 <vector189>:
.globl vector189
vector189:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $189
80106365:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010636a:	e9 cf f3 ff ff       	jmp    8010573e <alltraps>

8010636f <vector190>:
.globl vector190
vector190:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $190
80106371:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106376:	e9 c3 f3 ff ff       	jmp    8010573e <alltraps>

8010637b <vector191>:
.globl vector191
vector191:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $191
8010637d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106382:	e9 b7 f3 ff ff       	jmp    8010573e <alltraps>

80106387 <vector192>:
.globl vector192
vector192:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $192
80106389:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010638e:	e9 ab f3 ff ff       	jmp    8010573e <alltraps>

80106393 <vector193>:
.globl vector193
vector193:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $193
80106395:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010639a:	e9 9f f3 ff ff       	jmp    8010573e <alltraps>

8010639f <vector194>:
.globl vector194
vector194:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $194
801063a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063a6:	e9 93 f3 ff ff       	jmp    8010573e <alltraps>

801063ab <vector195>:
.globl vector195
vector195:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $195
801063ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063b2:	e9 87 f3 ff ff       	jmp    8010573e <alltraps>

801063b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $196
801063b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063be:	e9 7b f3 ff ff       	jmp    8010573e <alltraps>

801063c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $197
801063c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ca:	e9 6f f3 ff ff       	jmp    8010573e <alltraps>

801063cf <vector198>:
.globl vector198
vector198:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $198
801063d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063d6:	e9 63 f3 ff ff       	jmp    8010573e <alltraps>

801063db <vector199>:
.globl vector199
vector199:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $199
801063dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063e2:	e9 57 f3 ff ff       	jmp    8010573e <alltraps>

801063e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $200
801063e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063ee:	e9 4b f3 ff ff       	jmp    8010573e <alltraps>

801063f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $201
801063f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063fa:	e9 3f f3 ff ff       	jmp    8010573e <alltraps>

801063ff <vector202>:
.globl vector202
vector202:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $202
80106401:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106406:	e9 33 f3 ff ff       	jmp    8010573e <alltraps>

8010640b <vector203>:
.globl vector203
vector203:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $203
8010640d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106412:	e9 27 f3 ff ff       	jmp    8010573e <alltraps>

80106417 <vector204>:
.globl vector204
vector204:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $204
80106419:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010641e:	e9 1b f3 ff ff       	jmp    8010573e <alltraps>

80106423 <vector205>:
.globl vector205
vector205:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $205
80106425:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010642a:	e9 0f f3 ff ff       	jmp    8010573e <alltraps>

8010642f <vector206>:
.globl vector206
vector206:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $206
80106431:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106436:	e9 03 f3 ff ff       	jmp    8010573e <alltraps>

8010643b <vector207>:
.globl vector207
vector207:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $207
8010643d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106442:	e9 f7 f2 ff ff       	jmp    8010573e <alltraps>

80106447 <vector208>:
.globl vector208
vector208:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $208
80106449:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010644e:	e9 eb f2 ff ff       	jmp    8010573e <alltraps>

80106453 <vector209>:
.globl vector209
vector209:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $209
80106455:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010645a:	e9 df f2 ff ff       	jmp    8010573e <alltraps>

8010645f <vector210>:
.globl vector210
vector210:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $210
80106461:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106466:	e9 d3 f2 ff ff       	jmp    8010573e <alltraps>

8010646b <vector211>:
.globl vector211
vector211:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $211
8010646d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106472:	e9 c7 f2 ff ff       	jmp    8010573e <alltraps>

80106477 <vector212>:
.globl vector212
vector212:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $212
80106479:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010647e:	e9 bb f2 ff ff       	jmp    8010573e <alltraps>

80106483 <vector213>:
.globl vector213
vector213:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $213
80106485:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010648a:	e9 af f2 ff ff       	jmp    8010573e <alltraps>

8010648f <vector214>:
.globl vector214
vector214:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $214
80106491:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106496:	e9 a3 f2 ff ff       	jmp    8010573e <alltraps>

8010649b <vector215>:
.globl vector215
vector215:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $215
8010649d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064a2:	e9 97 f2 ff ff       	jmp    8010573e <alltraps>

801064a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $216
801064a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064ae:	e9 8b f2 ff ff       	jmp    8010573e <alltraps>

801064b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $217
801064b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064ba:	e9 7f f2 ff ff       	jmp    8010573e <alltraps>

801064bf <vector218>:
.globl vector218
vector218:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $218
801064c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064c6:	e9 73 f2 ff ff       	jmp    8010573e <alltraps>

801064cb <vector219>:
.globl vector219
vector219:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $219
801064cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064d2:	e9 67 f2 ff ff       	jmp    8010573e <alltraps>

801064d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $220
801064d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064de:	e9 5b f2 ff ff       	jmp    8010573e <alltraps>

801064e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $221
801064e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064ea:	e9 4f f2 ff ff       	jmp    8010573e <alltraps>

801064ef <vector222>:
.globl vector222
vector222:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $222
801064f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064f6:	e9 43 f2 ff ff       	jmp    8010573e <alltraps>

801064fb <vector223>:
.globl vector223
vector223:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $223
801064fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106502:	e9 37 f2 ff ff       	jmp    8010573e <alltraps>

80106507 <vector224>:
.globl vector224
vector224:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $224
80106509:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010650e:	e9 2b f2 ff ff       	jmp    8010573e <alltraps>

80106513 <vector225>:
.globl vector225
vector225:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $225
80106515:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010651a:	e9 1f f2 ff ff       	jmp    8010573e <alltraps>

8010651f <vector226>:
.globl vector226
vector226:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $226
80106521:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106526:	e9 13 f2 ff ff       	jmp    8010573e <alltraps>

8010652b <vector227>:
.globl vector227
vector227:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $227
8010652d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106532:	e9 07 f2 ff ff       	jmp    8010573e <alltraps>

80106537 <vector228>:
.globl vector228
vector228:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $228
80106539:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010653e:	e9 fb f1 ff ff       	jmp    8010573e <alltraps>

80106543 <vector229>:
.globl vector229
vector229:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $229
80106545:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010654a:	e9 ef f1 ff ff       	jmp    8010573e <alltraps>

8010654f <vector230>:
.globl vector230
vector230:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $230
80106551:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106556:	e9 e3 f1 ff ff       	jmp    8010573e <alltraps>

8010655b <vector231>:
.globl vector231
vector231:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $231
8010655d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106562:	e9 d7 f1 ff ff       	jmp    8010573e <alltraps>

80106567 <vector232>:
.globl vector232
vector232:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $232
80106569:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010656e:	e9 cb f1 ff ff       	jmp    8010573e <alltraps>

80106573 <vector233>:
.globl vector233
vector233:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $233
80106575:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010657a:	e9 bf f1 ff ff       	jmp    8010573e <alltraps>

8010657f <vector234>:
.globl vector234
vector234:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $234
80106581:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106586:	e9 b3 f1 ff ff       	jmp    8010573e <alltraps>

8010658b <vector235>:
.globl vector235
vector235:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $235
8010658d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106592:	e9 a7 f1 ff ff       	jmp    8010573e <alltraps>

80106597 <vector236>:
.globl vector236
vector236:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $236
80106599:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010659e:	e9 9b f1 ff ff       	jmp    8010573e <alltraps>

801065a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $237
801065a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065aa:	e9 8f f1 ff ff       	jmp    8010573e <alltraps>

801065af <vector238>:
.globl vector238
vector238:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $238
801065b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065b6:	e9 83 f1 ff ff       	jmp    8010573e <alltraps>

801065bb <vector239>:
.globl vector239
vector239:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $239
801065bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065c2:	e9 77 f1 ff ff       	jmp    8010573e <alltraps>

801065c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $240
801065c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ce:	e9 6b f1 ff ff       	jmp    8010573e <alltraps>

801065d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $241
801065d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065da:	e9 5f f1 ff ff       	jmp    8010573e <alltraps>

801065df <vector242>:
.globl vector242
vector242:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $242
801065e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065e6:	e9 53 f1 ff ff       	jmp    8010573e <alltraps>

801065eb <vector243>:
.globl vector243
vector243:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $243
801065ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065f2:	e9 47 f1 ff ff       	jmp    8010573e <alltraps>

801065f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $244
801065f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065fe:	e9 3b f1 ff ff       	jmp    8010573e <alltraps>

80106603 <vector245>:
.globl vector245
vector245:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $245
80106605:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010660a:	e9 2f f1 ff ff       	jmp    8010573e <alltraps>

8010660f <vector246>:
.globl vector246
vector246:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $246
80106611:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106616:	e9 23 f1 ff ff       	jmp    8010573e <alltraps>

8010661b <vector247>:
.globl vector247
vector247:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $247
8010661d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106622:	e9 17 f1 ff ff       	jmp    8010573e <alltraps>

80106627 <vector248>:
.globl vector248
vector248:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $248
80106629:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010662e:	e9 0b f1 ff ff       	jmp    8010573e <alltraps>

80106633 <vector249>:
.globl vector249
vector249:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $249
80106635:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010663a:	e9 ff f0 ff ff       	jmp    8010573e <alltraps>

8010663f <vector250>:
.globl vector250
vector250:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $250
80106641:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106646:	e9 f3 f0 ff ff       	jmp    8010573e <alltraps>

8010664b <vector251>:
.globl vector251
vector251:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $251
8010664d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106652:	e9 e7 f0 ff ff       	jmp    8010573e <alltraps>

80106657 <vector252>:
.globl vector252
vector252:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $252
80106659:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010665e:	e9 db f0 ff ff       	jmp    8010573e <alltraps>

80106663 <vector253>:
.globl vector253
vector253:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $253
80106665:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010666a:	e9 cf f0 ff ff       	jmp    8010573e <alltraps>

8010666f <vector254>:
.globl vector254
vector254:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $254
80106671:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106676:	e9 c3 f0 ff ff       	jmp    8010573e <alltraps>

8010667b <vector255>:
.globl vector255
vector255:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $255
8010667d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106682:	e9 b7 f0 ff ff       	jmp    8010573e <alltraps>
80106687:	66 90                	xchg   %ax,%ax
80106689:	66 90                	xchg   %ax,%ax
8010668b:	66 90                	xchg   %ax,%ax
8010668d:	66 90                	xchg   %ax,%ax
8010668f:	90                   	nop

80106690 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	57                   	push   %edi
80106694:	56                   	push   %esi
80106695:	53                   	push   %ebx
80106696:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106698:	c1 ea 16             	shr    $0x16,%edx
8010669b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010669e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801066a1:	8b 07                	mov    (%edi),%eax
801066a3:	a8 01                	test   $0x1,%al
801066a5:	74 29                	je     801066d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066ac:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066b5:	c1 eb 0a             	shr    $0xa,%ebx
801066b8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801066be:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801066c1:	5b                   	pop    %ebx
801066c2:	5e                   	pop    %esi
801066c3:	5f                   	pop    %edi
801066c4:	5d                   	pop    %ebp
801066c5:	c3                   	ret    
801066c6:	8d 76 00             	lea    0x0(%esi),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066d0:	85 c9                	test   %ecx,%ecx
801066d2:	74 2c                	je     80106700 <walkpgdir+0x70>
801066d4:	e8 97 bd ff ff       	call   80102470 <kalloc>
801066d9:	85 c0                	test   %eax,%eax
801066db:	89 c6                	mov    %eax,%esi
801066dd:	74 21                	je     80106700 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801066df:	83 ec 04             	sub    $0x4,%esp
801066e2:	68 00 10 00 00       	push   $0x1000
801066e7:	6a 00                	push   $0x0
801066e9:	50                   	push   %eax
801066ea:	e8 e1 dd ff ff       	call   801044d0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066ef:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066f5:	83 c4 10             	add    $0x10,%esp
801066f8:	83 c8 07             	or     $0x7,%eax
801066fb:	89 07                	mov    %eax,(%edi)
801066fd:	eb b3                	jmp    801066b2 <walkpgdir+0x22>
801066ff:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106703:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106705:	5b                   	pop    %ebx
80106706:	5e                   	pop    %esi
80106707:	5f                   	pop    %edi
80106708:	5d                   	pop    %ebp
80106709:	c3                   	ret    
8010670a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106710 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
80106715:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106716:	89 d3                	mov    %edx,%ebx
80106718:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010671e:	83 ec 1c             	sub    $0x1c,%esp
80106721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106724:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106728:	8b 7d 08             	mov    0x8(%ebp),%edi
8010672b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106730:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106733:	8b 45 0c             	mov    0xc(%ebp),%eax
80106736:	29 df                	sub    %ebx,%edi
80106738:	83 c8 01             	or     $0x1,%eax
8010673b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010673e:	eb 15                	jmp    80106755 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106740:	f6 00 01             	testb  $0x1,(%eax)
80106743:	75 45                	jne    8010678a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106745:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106748:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010674b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010674d:	74 31                	je     80106780 <mappages+0x70>
      break;
    a += PGSIZE;
8010674f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106758:	b9 01 00 00 00       	mov    $0x1,%ecx
8010675d:	89 da                	mov    %ebx,%edx
8010675f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106762:	e8 29 ff ff ff       	call   80106690 <walkpgdir>
80106767:	85 c0                	test   %eax,%eax
80106769:	75 d5                	jne    80106740 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010676b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010676e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106773:	5b                   	pop    %ebx
80106774:	5e                   	pop    %esi
80106775:	5f                   	pop    %edi
80106776:	5d                   	pop    %ebp
80106777:	c3                   	ret    
80106778:	90                   	nop
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106780:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106783:	31 c0                	xor    %eax,%eax
}
80106785:	5b                   	pop    %ebx
80106786:	5e                   	pop    %esi
80106787:	5f                   	pop    %edi
80106788:	5d                   	pop    %ebp
80106789:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010678a:	83 ec 0c             	sub    $0xc,%esp
8010678d:	68 88 78 10 80       	push   $0x80107888
80106792:	e8 d9 9b ff ff       	call   80100370 <panic>
80106797:	89 f6                	mov    %esi,%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067ac:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067b4:	83 ec 1c             	sub    $0x1c,%esp
801067b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067ba:	39 d3                	cmp    %edx,%ebx
801067bc:	73 66                	jae    80106824 <deallocuvm.part.0+0x84>
801067be:	89 d6                	mov    %edx,%esi
801067c0:	eb 3d                	jmp    801067ff <deallocuvm.part.0+0x5f>
801067c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067c8:	8b 10                	mov    (%eax),%edx
801067ca:	f6 c2 01             	test   $0x1,%dl
801067cd:	74 26                	je     801067f5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067d5:	74 58                	je     8010682f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801067d7:	83 ec 0c             	sub    $0xc,%esp
801067da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067e3:	52                   	push   %edx
801067e4:	e8 d7 ba ff ff       	call   801022c0 <kfree>
      *pte = 0;
801067e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ec:	83 c4 10             	add    $0x10,%esp
801067ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067fb:	39 f3                	cmp    %esi,%ebx
801067fd:	73 25                	jae    80106824 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067ff:	31 c9                	xor    %ecx,%ecx
80106801:	89 da                	mov    %ebx,%edx
80106803:	89 f8                	mov    %edi,%eax
80106805:	e8 86 fe ff ff       	call   80106690 <walkpgdir>
    if(!pte)
8010680a:	85 c0                	test   %eax,%eax
8010680c:	75 ba                	jne    801067c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010680e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106814:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010681a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106820:	39 f3                	cmp    %esi,%ebx
80106822:	72 db                	jb     801067ff <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106824:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106827:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010682a:	5b                   	pop    %ebx
8010682b:	5e                   	pop    %esi
8010682c:	5f                   	pop    %edi
8010682d:	5d                   	pop    %ebp
8010682e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010682f:	83 ec 0c             	sub    $0xc,%esp
80106832:	68 52 72 10 80       	push   $0x80107252
80106837:	e8 34 9b ff ff       	call   80100370 <panic>
8010683c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106840 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106844:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106846:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106849:	e8 82 be ff ff       	call   801026d0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010684e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106854:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106859:	8d 90 a0 27 11 80    	lea    -0x7feed860(%eax),%edx
8010685f:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
80106866:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010686d:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
80106874:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010687b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010687f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106884:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106888:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
8010688f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106891:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106896:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010689d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
801068a4:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068a6:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068ab:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068b2:	31 db                	xor    %ebx,%ebx
801068b4:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068bb:	8d 88 54 28 11 80    	lea    -0x7feed7ac(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068c1:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068c8:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068ca:	c6 80 35 28 11 80 fa 	movb   $0xfa,-0x7feed7cb(%eax)
801068d1:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068d8:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
801068df:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
801068e6:	89 cb                	mov    %ecx,%ebx
801068e8:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068eb:	c6 80 3d 28 11 80 f2 	movb   $0xf2,-0x7feed7c3(%eax)
801068f2:	c6 80 3e 28 11 80 cf 	movb   $0xcf,-0x7feed7c2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068f9:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
801068ff:	c6 80 2d 28 11 80 92 	movb   $0x92,-0x7feed7d3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106906:	b9 37 00 00 00       	mov    $0x37,%ecx
8010690b:	c6 80 2e 28 11 80 c0 	movb   $0xc0,-0x7feed7d2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106912:	05 10 28 11 80       	add    $0x80112810,%eax
80106917:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010691b:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
8010691e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106922:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106925:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
80106929:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010692d:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
80106934:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010693b:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106942:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106949:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106950:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106957:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
8010695d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106961:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106964:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106967:	b8 18 00 00 00       	mov    $0x18,%eax
8010696c:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
8010696e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106975:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106979:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106980:	83 c4 14             	add    $0x14,%esp
80106983:	5b                   	pop    %ebx
80106984:	5d                   	pop    %ebp
80106985:	c3                   	ret    
80106986:	8d 76 00             	lea    0x0(%esi),%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	56                   	push   %esi
80106994:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106995:	e8 d6 ba ff ff       	call   80102470 <kalloc>
8010699a:	85 c0                	test   %eax,%eax
8010699c:	74 52                	je     801069f0 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010699e:	83 ec 04             	sub    $0x4,%esp
801069a1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069a3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801069a8:	68 00 10 00 00       	push   $0x1000
801069ad:	6a 00                	push   $0x0
801069af:	50                   	push   %eax
801069b0:	e8 1b db ff ff       	call   801044d0 <memset>
801069b5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069b8:	8b 43 04             	mov    0x4(%ebx),%eax
801069bb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801069be:	83 ec 08             	sub    $0x8,%esp
801069c1:	8b 13                	mov    (%ebx),%edx
801069c3:	ff 73 0c             	pushl  0xc(%ebx)
801069c6:	50                   	push   %eax
801069c7:	29 c1                	sub    %eax,%ecx
801069c9:	89 f0                	mov    %esi,%eax
801069cb:	e8 40 fd ff ff       	call   80106710 <mappages>
801069d0:	83 c4 10             	add    $0x10,%esp
801069d3:	85 c0                	test   %eax,%eax
801069d5:	78 19                	js     801069f0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069d7:	83 c3 10             	add    $0x10,%ebx
801069da:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069e0:	75 d6                	jne    801069b8 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069e5:	89 f0                	mov    %esi,%eax
801069e7:	5b                   	pop    %ebx
801069e8:	5e                   	pop    %esi
801069e9:	5d                   	pop    %ebp
801069ea:	c3                   	ret    
801069eb:	90                   	nop
801069ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801069f3:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069f5:	5b                   	pop    %ebx
801069f6:	5e                   	pop    %esi
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    
801069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a00 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a06:	e8 85 ff ff ff       	call   80106990 <setupkvm>
80106a0b:	a3 24 76 11 80       	mov    %eax,0x80117624
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a10:	05 00 00 00 80       	add    $0x80000000,%eax
80106a15:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106a18:	c9                   	leave  
80106a19:	c3                   	ret    
80106a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a20 <switchkvm>:
80106a20:	a1 24 76 11 80       	mov    0x80117624,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106a25:	55                   	push   %ebp
80106a26:	89 e5                	mov    %esp,%ebp
80106a28:	05 00 00 00 80       	add    $0x80000000,%eax
80106a2d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106a30:	5d                   	pop    %ebp
80106a31:	c3                   	ret    
80106a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	53                   	push   %ebx
80106a44:	83 ec 04             	sub    $0x4,%esp
80106a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106a4a:	85 db                	test   %ebx,%ebx
80106a4c:	0f 84 93 00 00 00    	je     80106ae5 <switchuvm+0xa5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106a52:	8b 43 08             	mov    0x8(%ebx),%eax
80106a55:	85 c0                	test   %eax,%eax
80106a57:	0f 84 a2 00 00 00    	je     80106aff <switchuvm+0xbf>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106a5d:	8b 43 04             	mov    0x4(%ebx),%eax
80106a60:	85 c0                	test   %eax,%eax
80106a62:	0f 84 8a 00 00 00    	je     80106af2 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106a68:	e8 93 d9 ff ff       	call   80104400 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a73:	b9 67 00 00 00       	mov    $0x67,%ecx
80106a78:	8d 50 08             	lea    0x8(%eax),%edx
80106a7b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106a82:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106a89:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a90:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106a97:	89 d1                	mov    %edx,%ecx
80106a99:	c1 ea 18             	shr    $0x18,%edx
80106a9c:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106aa2:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106aa5:	ba 10 00 00 00       	mov    $0x10,%edx
80106aaa:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106aae:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ab4:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ab7:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106abd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106ac2:	66 89 48 6e          	mov    %cx,0x6e(%eax)

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ac6:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106ac9:	b8 30 00 00 00       	mov    $0x30,%eax
80106ace:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ad1:	8b 43 04             	mov    0x4(%ebx),%eax
80106ad4:	05 00 00 00 80       	add    $0x80000000,%eax
80106ad9:	0f 22 d8             	mov    %eax,%cr3
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106adf:	c9                   	leave  
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106ae0:	e9 4b d9 ff ff       	jmp    80104430 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106ae5:	83 ec 0c             	sub    $0xc,%esp
80106ae8:	68 8e 78 10 80       	push   $0x8010788e
80106aed:	e8 7e 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	68 b9 78 10 80       	push   $0x801078b9
80106afa:	e8 71 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106aff:	83 ec 0c             	sub    $0xc,%esp
80106b02:	68 a4 78 10 80       	push   $0x801078a4
80106b07:	e8 64 98 ff ff       	call   80100370 <panic>
80106b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 1c             	sub    $0x1c,%esp
80106b19:	8b 75 10             	mov    0x10(%ebp),%esi
80106b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106b22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106b2b:	77 49                	ja     80106b76 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106b2d:	e8 3e b9 ff ff       	call   80102470 <kalloc>
  memset(mem, 0, PGSIZE);
80106b32:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106b35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b37:	68 00 10 00 00       	push   $0x1000
80106b3c:	6a 00                	push   $0x0
80106b3e:	50                   	push   %eax
80106b3f:	e8 8c d9 ff ff       	call   801044d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b44:	58                   	pop    %eax
80106b45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b50:	5a                   	pop    %edx
80106b51:	6a 06                	push   $0x6
80106b53:	50                   	push   %eax
80106b54:	31 d2                	xor    %edx,%edx
80106b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b59:	e8 b2 fb ff ff       	call   80106710 <mappages>
  memmove(mem, init, sz);
80106b5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b64:	83 c4 10             	add    $0x10,%esp
80106b67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b6d:	5b                   	pop    %ebx
80106b6e:	5e                   	pop    %esi
80106b6f:	5f                   	pop    %edi
80106b70:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b71:	e9 0a da ff ff       	jmp    80104580 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	68 cd 78 10 80       	push   $0x801078cd
80106b7e:	e8 ed 97 ff ff       	call   80100370 <panic>
80106b83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ba0:	0f 85 91 00 00 00    	jne    80106c37 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106ba6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ba9:	31 db                	xor    %ebx,%ebx
80106bab:	85 f6                	test   %esi,%esi
80106bad:	75 1a                	jne    80106bc9 <loaduvm+0x39>
80106baf:	eb 6f                	jmp    80106c20 <loaduvm+0x90>
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106bc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106bc7:	76 57                	jbe    80106c20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcf:	31 c9                	xor    %ecx,%ecx
80106bd1:	01 da                	add    %ebx,%edx
80106bd3:	e8 b8 fa ff ff       	call   80106690 <walkpgdir>
80106bd8:	85 c0                	test   %eax,%eax
80106bda:	74 4e                	je     80106c2a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106bdc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106be1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106beb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bf1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bf4:	01 d9                	add    %ebx,%ecx
80106bf6:	05 00 00 00 80       	add    $0x80000000,%eax
80106bfb:	57                   	push   %edi
80106bfc:	51                   	push   %ecx
80106bfd:	50                   	push   %eax
80106bfe:	ff 75 10             	pushl  0x10(%ebp)
80106c01:	e8 0a ad ff ff       	call   80101910 <readi>
80106c06:	83 c4 10             	add    $0x10,%esp
80106c09:	39 c7                	cmp    %eax,%edi
80106c0b:	74 ab                	je     80106bb8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106c15:	5b                   	pop    %ebx
80106c16:	5e                   	pop    %esi
80106c17:	5f                   	pop    %edi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106c23:	31 c0                	xor    %eax,%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	68 e7 78 10 80       	push   $0x801078e7
80106c32:	e8 39 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106c37:	83 ec 0c             	sub    $0xc,%esp
80106c3a:	68 88 79 10 80       	push   $0x80107988
80106c3f:	e8 2c 97 ff ff       	call   80100370 <panic>
80106c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c50 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 0c             	sub    $0xc,%esp
80106c59:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106c5c:	85 ff                	test   %edi,%edi
80106c5e:	0f 88 ca 00 00 00    	js     80106d2e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c6a:	0f 82 82 00 00 00    	jb     80106cf2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c7c:	39 df                	cmp    %ebx,%edi
80106c7e:	77 43                	ja     80106cc3 <allocuvm+0x73>
80106c80:	e9 bb 00 00 00       	jmp    80106d40 <allocuvm+0xf0>
80106c85:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c88:	83 ec 04             	sub    $0x4,%esp
80106c8b:	68 00 10 00 00       	push   $0x1000
80106c90:	6a 00                	push   $0x0
80106c92:	50                   	push   %eax
80106c93:	e8 38 d8 ff ff       	call   801044d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c98:	58                   	pop    %eax
80106c99:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c9f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ca4:	5a                   	pop    %edx
80106ca5:	6a 06                	push   $0x6
80106ca7:	50                   	push   %eax
80106ca8:	89 da                	mov    %ebx,%edx
80106caa:	8b 45 08             	mov    0x8(%ebp),%eax
80106cad:	e8 5e fa ff ff       	call   80106710 <mappages>
80106cb2:	83 c4 10             	add    $0x10,%esp
80106cb5:	85 c0                	test   %eax,%eax
80106cb7:	78 47                	js     80106d00 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cbf:	39 df                	cmp    %ebx,%edi
80106cc1:	76 7d                	jbe    80106d40 <allocuvm+0xf0>
    mem = kalloc();
80106cc3:	e8 a8 b7 ff ff       	call   80102470 <kalloc>
    if(mem == 0){
80106cc8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106cca:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ccc:	75 ba                	jne    80106c88 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106cce:	83 ec 0c             	sub    $0xc,%esp
80106cd1:	68 05 79 10 80       	push   $0x80107905
80106cd6:	e8 85 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cdb:	83 c4 10             	add    $0x10,%esp
80106cde:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ce1:	76 4b                	jbe    80106d2e <allocuvm+0xde>
80106ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce9:	89 fa                	mov    %edi,%edx
80106ceb:	e8 b0 fa ff ff       	call   801067a0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106cf0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106d00:	83 ec 0c             	sub    $0xc,%esp
80106d03:	68 1d 79 10 80       	push   $0x8010791d
80106d08:	e8 53 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d0d:	83 c4 10             	add    $0x10,%esp
80106d10:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d13:	76 0d                	jbe    80106d22 <allocuvm+0xd2>
80106d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d18:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1b:	89 fa                	mov    %edi,%edx
80106d1d:	e8 7e fa ff ff       	call   801067a0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106d22:	83 ec 0c             	sub    $0xc,%esp
80106d25:	56                   	push   %esi
80106d26:	e8 95 b5 ff ff       	call   801022c0 <kfree>
      return 0;
80106d2b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106d31:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106d33:	5b                   	pop    %ebx
80106d34:	5e                   	pop    %esi
80106d35:	5f                   	pop    %edi
80106d36:	5d                   	pop    %ebp
80106d37:	c3                   	ret    
80106d38:	90                   	nop
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d43:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d59:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d5c:	39 d1                	cmp    %edx,%ecx
80106d5e:	73 10                	jae    80106d70 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d60:	5d                   	pop    %ebp
80106d61:	e9 3a fa ff ff       	jmp    801067a0 <deallocuvm.part.0>
80106d66:	8d 76 00             	lea    0x0(%esi),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d70:	89 d0                	mov    %edx,%eax
80106d72:	5d                   	pop    %ebp
80106d73:	c3                   	ret    
80106d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 0c             	sub    $0xc,%esp
80106d89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d8c:	85 f6                	test   %esi,%esi
80106d8e:	74 59                	je     80106de9 <freevm+0x69>
80106d90:	31 c9                	xor    %ecx,%ecx
80106d92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d97:	89 f0                	mov    %esi,%eax
80106d99:	e8 02 fa ff ff       	call   801067a0 <deallocuvm.part.0>
80106d9e:	89 f3                	mov    %esi,%ebx
80106da0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106da6:	eb 0f                	jmp    80106db7 <freevm+0x37>
80106da8:	90                   	nop
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106db3:	39 fb                	cmp    %edi,%ebx
80106db5:	74 23                	je     80106dda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106db7:	8b 03                	mov    (%ebx),%eax
80106db9:	a8 01                	test   $0x1,%al
80106dbb:	74 f3                	je     80106db0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106dbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dc2:	83 ec 0c             	sub    $0xc,%esp
80106dc5:	83 c3 04             	add    $0x4,%ebx
80106dc8:	05 00 00 00 80       	add    $0x80000000,%eax
80106dcd:	50                   	push   %eax
80106dce:	e8 ed b4 ff ff       	call   801022c0 <kfree>
80106dd3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106dd6:	39 fb                	cmp    %edi,%ebx
80106dd8:	75 dd                	jne    80106db7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106dda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de0:	5b                   	pop    %ebx
80106de1:	5e                   	pop    %esi
80106de2:	5f                   	pop    %edi
80106de3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106de4:	e9 d7 b4 ff ff       	jmp    801022c0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106de9:	83 ec 0c             	sub    $0xc,%esp
80106dec:	68 39 79 10 80       	push   $0x80107939
80106df1:	e8 7a 95 ff ff       	call   80100370 <panic>
80106df6:	8d 76 00             	lea    0x0(%esi),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e01:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e03:	89 e5                	mov    %esp,%ebp
80106e05:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e0e:	e8 7d f8 ff ff       	call   80106690 <walkpgdir>
  if(pte == 0)
80106e13:	85 c0                	test   %eax,%eax
80106e15:	74 05                	je     80106e1c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e1a:	c9                   	leave  
80106e1b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 4a 79 10 80       	push   $0x8010794a
80106e24:	e8 47 95 ff ff       	call   80100370 <panic>
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e39:	e8 52 fb ff ff       	call   80106990 <setupkvm>
80106e3e:	85 c0                	test   %eax,%eax
80106e40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e43:	0f 84 b2 00 00 00    	je     80106efb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e4c:	85 c9                	test   %ecx,%ecx
80106e4e:	0f 84 9c 00 00 00    	je     80106ef0 <copyuvm+0xc0>
80106e54:	31 f6                	xor    %esi,%esi
80106e56:	eb 4a                	jmp    80106ea2 <copyuvm+0x72>
80106e58:	90                   	nop
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e60:	83 ec 04             	sub    $0x4,%esp
80106e63:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e69:	68 00 10 00 00       	push   $0x1000
80106e6e:	57                   	push   %edi
80106e6f:	50                   	push   %eax
80106e70:	e8 0b d7 ff ff       	call   80104580 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e75:	58                   	pop    %eax
80106e76:	5a                   	pop    %edx
80106e77:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e80:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e83:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e88:	52                   	push   %edx
80106e89:	89 f2                	mov    %esi,%edx
80106e8b:	e8 80 f8 ff ff       	call   80106710 <mappages>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	85 c0                	test   %eax,%eax
80106e95:	78 3e                	js     80106ed5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e97:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e9d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106ea0:	76 4e                	jbe    80106ef0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea5:	31 c9                	xor    %ecx,%ecx
80106ea7:	89 f2                	mov    %esi,%edx
80106ea9:	e8 e2 f7 ff ff       	call   80106690 <walkpgdir>
80106eae:	85 c0                	test   %eax,%eax
80106eb0:	74 5a                	je     80106f0c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106eb2:	8b 18                	mov    (%eax),%ebx
80106eb4:	f6 c3 01             	test   $0x1,%bl
80106eb7:	74 46                	je     80106eff <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106eb9:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106ebb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106ec1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ec4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106eca:	e8 a1 b5 ff ff       	call   80102470 <kalloc>
80106ecf:	85 c0                	test   %eax,%eax
80106ed1:	89 c3                	mov    %eax,%ebx
80106ed3:	75 8b                	jne    80106e60 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ed5:	83 ec 0c             	sub    $0xc,%esp
80106ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80106edb:	e8 a0 fe ff ff       	call   80106d80 <freevm>
  return 0;
80106ee0:	83 c4 10             	add    $0x10,%esp
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee8:	5b                   	pop    %ebx
80106ee9:	5e                   	pop    %esi
80106eea:	5f                   	pop    %edi
80106eeb:	5d                   	pop    %ebp
80106eec:	c3                   	ret    
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef6:	5b                   	pop    %ebx
80106ef7:	5e                   	pop    %esi
80106ef8:	5f                   	pop    %edi
80106ef9:	5d                   	pop    %ebp
80106efa:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106efb:	31 c0                	xor    %eax,%eax
80106efd:	eb e6                	jmp    80106ee5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106eff:	83 ec 0c             	sub    $0xc,%esp
80106f02:	68 6e 79 10 80       	push   $0x8010796e
80106f07:	e8 64 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	68 54 79 10 80       	push   $0x80107954
80106f14:	e8 57 94 ff ff       	call   80100370 <panic>
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f21:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2e:	e8 5d f7 ff ff       	call   80106690 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f33:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f35:	89 c2                	mov    %eax,%edx
80106f37:	83 e2 05             	and    $0x5,%edx
80106f3a:	83 fa 05             	cmp    $0x5,%edx
80106f3d:	75 11                	jne    80106f50 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f44:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f45:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f4a:	c3                   	ret    
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f50:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f52:	c9                   	leave  
80106f53:	c3                   	ret    
80106f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f72:	85 db                	test   %ebx,%ebx
80106f74:	75 40                	jne    80106fb6 <copyout+0x56>
80106f76:	eb 70                	jmp    80106fe8 <copyout+0x88>
80106f78:	90                   	nop
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f83:	89 f1                	mov    %esi,%ecx
80106f85:	29 d1                	sub    %edx,%ecx
80106f87:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f8d:	39 d9                	cmp    %ebx,%ecx
80106f8f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f92:	29 f2                	sub    %esi,%edx
80106f94:	83 ec 04             	sub    $0x4,%esp
80106f97:	01 d0                	add    %edx,%eax
80106f99:	51                   	push   %ecx
80106f9a:	57                   	push   %edi
80106f9b:	50                   	push   %eax
80106f9c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f9f:	e8 dc d5 ff ff       	call   80104580 <memmove>
    len -= n;
    buf += n;
80106fa4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fa7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106faa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106fb0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fb2:	29 cb                	sub    %ecx,%ebx
80106fb4:	74 32                	je     80106fe8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106fb6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fb8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106fbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106fbe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fc4:	56                   	push   %esi
80106fc5:	ff 75 08             	pushl  0x8(%ebp)
80106fc8:	e8 53 ff ff ff       	call   80106f20 <uva2ka>
    if(pa0 == 0)
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	85 c0                	test   %eax,%eax
80106fd2:	75 ac                	jne    80106f80 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fdc:	5b                   	pop    %ebx
80106fdd:	5e                   	pop    %esi
80106fde:	5f                   	pop    %edi
80106fdf:	5d                   	pop    %ebp
80106fe0:	c3                   	ret    
80106fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106feb:	31 c0                	xor    %eax,%eax
}
80106fed:	5b                   	pop    %ebx
80106fee:	5e                   	pop    %esi
80106fef:	5f                   	pop    %edi
80106ff0:	5d                   	pop    %ebp
80106ff1:	c3                   	ret    
